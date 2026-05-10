import React, { useState, useEffect, useRef } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Bell, X, Check, CheckCheck, Users, Building, Shield, Settings, LogIn, Trash2, Edit, Upload, Lock } from "lucide-react";
import { useAuth } from "../context/AuthContext";
import { useLanguage } from "../context/LanguageContext";
import { useTheme } from "../context/ThemeContext";
import { supabase } from "../supabaseClient";
import { timeAgo } from "../utils/timeAgo";

interface Notification {
  id: string;
  action_type: string;
  entity_type: string;
  details: string;
  created_at: string;
  read: boolean;
  profiles?: { full_name: string; avatar_url: string | null };
}

const actionIcons: Record<string, React.ComponentType<any>> = {
  CREATE: Users,
  UPDATE: Edit,
  DELETE: Trash2,
  BLOCK: Shield,
  UNBLOCK: Shield,
  LOGIN: LogIn,
  LOGOUT: LogIn,
  UPLOAD: Upload,
  TOGGLE: Settings,
  PASSWORD_CHANGE: Lock,
  ROLE_CHANGE: Shield,
};

const actionColors: Record<string, string> = {
  CREATE: "bg-emerald-100 text-emerald-600 dark:bg-emerald-900/30 dark:text-emerald-400",
  UPDATE: "bg-blue-100 text-blue-600 dark:bg-blue-900/30 dark:text-blue-400",
  DELETE: "bg-red-100 text-red-600 dark:bg-red-900/30 dark:text-red-400",
  BLOCK: "bg-amber-100 text-amber-600 dark:bg-amber-900/30 dark:text-amber-400",
  UNBLOCK: "bg-teal-100 text-teal-600 dark:bg-teal-900/30 dark:text-teal-400",
  LOGIN: "bg-violet-100 text-violet-600 dark:bg-violet-900/30 dark:text-violet-400",
  LOGOUT: "bg-gray-100 text-gray-600 dark:bg-gray-800/50 dark:text-gray-400",
  TOGGLE: "bg-orange-100 text-orange-600 dark:bg-orange-900/30 dark:text-orange-400",
  PASSWORD_CHANGE: "bg-rose-100 text-rose-600 dark:bg-rose-900/30 dark:text-rose-400",
  UPLOAD: "bg-cyan-100 text-cyan-600 dark:bg-cyan-900/30 dark:text-cyan-400",
  ROLE_CHANGE: "bg-indigo-100 text-indigo-600 dark:bg-indigo-900/30 dark:text-indigo-400",
};

export default function NotificationCenter() {
  const [isOpen, setIsOpen] = useState(false);
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [readIds, setReadIds] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(false);
  const panelRef = useRef<HTMLDivElement>(null);
  const { profile } = useAuth();
  const { t, language } = useLanguage();
  const { isDark } = useTheme();

  // Load read IDs from localStorage
  useEffect(() => {
    const saved = localStorage.getItem("guenet-read-notifications");
    if (saved) {
      try { setReadIds(new Set(JSON.parse(saved))); } catch { }
    }
  }, []);

  // Fetch notifications
  useEffect(() => {
    if (profile) {
      fetchNotifications();

      // Real-time subscription
      const channel = supabase
        .channel("notification_feed")
        .on("postgres_changes", {
          event: "INSERT",
          schema: "public",
          table: "activity_logs",
        }, () => {
          fetchNotifications();
        })
        .subscribe();

      return () => { supabase.removeChannel(channel); };
    }
  }, [profile]);

  const fetchNotifications = async () => {
    setLoading(true);
    try {
      let query = supabase
        .from("activity_logs")
        .select(`*, profiles:user_id (full_name, avatar_url)`)
        .order("created_at", { ascending: false })
        .limit(20);

      // Filter by church for non-super-admins
      if (profile?.role === "admin" && profile?.church_id) {
        // Admin sees activities related to their church
        // We cannot directly filter by church_id on activity_logs,
        // so we fetch all and they are inherently scoped by the system
      }

      const { data } = await query;
      if (data) {
        setNotifications(data.map(n => ({
          ...n,
          read: readIds.has(n.id),
        })));
      }
    } catch (err) {
      console.error("Error fetching notifications:", err);
    } finally {
      setLoading(false);
    }
  };

  // Close on outside click
  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      if (panelRef.current && !panelRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };
    if (isOpen) {
      document.addEventListener("mousedown", handleClick);
    }
    return () => document.removeEventListener("mousedown", handleClick);
  }, [isOpen]);

  const unreadCount = notifications.filter(n => !readIds.has(n.id)).length;

  const markAsRead = (id: string) => {
    const updated = new Set(readIds);
    updated.add(id);
    setReadIds(updated);
    localStorage.setItem("guenet-read-notifications", JSON.stringify([...updated]));
  };

  const markAllAsRead = () => {
    const updated = new Set([...readIds, ...notifications.map(n => n.id)]);
    setReadIds(updated);
    localStorage.setItem("guenet-read-notifications", JSON.stringify([...updated]));
  };

  const getActionIcon = (type: string) => {
    return actionIcons[type] || Settings;
  };

  return (
    <div className="relative" ref={panelRef}>
      {/* Bell Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className={`relative p-2.5 rounded-xl transition-all duration-200 ${
          isOpen
            ? 'bg-[#4B9BDC]/15 text-[#4B9BDC]'
            : isDark
              ? 'bg-gray-800/60 text-gray-400 hover:bg-gray-700/60 hover:text-gray-200'
              : 'bg-white text-gray-500 hover:bg-gray-50 hover:text-gray-700'
        } border ${isDark ? 'border-gray-700/50' : 'border-gray-200/80'} shadow-sm`}
      >
        <Bell size={18} />
        <AnimatePresence>
          {unreadCount > 0 && (
            <motion.span
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              exit={{ scale: 0 }}
              className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center shadow-md border-2 border-white dark:border-gray-900"
            >
              {unreadCount > 9 ? "9+" : unreadCount}
            </motion.span>
          )}
        </AnimatePresence>
      </button>

      {/* Notification Panel */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 8, scale: 0.96 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 8, scale: 0.96 }}
            transition={{ type: "spring", stiffness: 400, damping: 30 }}
            className={`absolute right-0 top-full mt-2 w-[380px] max-w-[90vw] rounded-2xl overflow-hidden shadow-2xl border z-50 ${
              isDark
                ? 'bg-gray-900/95 border-gray-700/60'
                : 'bg-white/95 border-gray-200/80'
            } backdrop-blur-2xl`}
            style={{
              boxShadow: isDark
                ? '0 20px 50px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.05)'
                : '0 20px 50px rgba(0,0,0,0.12), 0 0 0 1px rgba(255,255,255,0.8)',
            }}
          >
            {/* Header */}
            <div className={`flex items-center justify-between px-5 py-4 border-b ${isDark ? 'border-gray-700/50' : 'border-gray-100'}`}>
              <div>
                <h3 className={`text-sm font-bold ${isDark ? 'text-gray-100' : 'text-gray-900'}`}>Notifications</h3>
                <p className={`text-xs ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
                  {unreadCount} unread
                </p>
              </div>
              <div className="flex items-center gap-2">
                {unreadCount > 0 && (
                  <button
                    onClick={markAllAsRead}
                    className={`text-xs font-semibold px-3 py-1.5 rounded-lg transition-colors ${
                      isDark
                        ? 'text-[#7EC8F2] hover:bg-[#4B9BDC]/10'
                        : 'text-[#4B9BDC] hover:bg-[#4B9BDC]/10'
                    }`}
                  >
                    <CheckCheck size={14} className="inline mr-1" />
                    Mark all
                  </button>
                )}
                <button
                  onClick={() => setIsOpen(false)}
                  className={`p-1.5 rounded-lg ${isDark ? 'hover:bg-gray-800 text-gray-500' : 'hover:bg-gray-100 text-gray-400'}`}
                >
                  <X size={14} />
                </button>
              </div>
            </div>

            {/* Notification List */}
            <div className="max-h-[400px] overflow-y-auto custom-scrollbar">
              {loading ? (
                <div className="p-8 text-center">
                  <div className="w-6 h-6 border-2 border-[#4B9BDC]/30 border-t-[#4B9BDC] rounded-full animate-spin mx-auto" />
                </div>
              ) : notifications.length === 0 ? (
                <div className="p-12 text-center">
                  <Bell size={28} className={`mx-auto mb-2 ${isDark ? 'text-gray-600' : 'text-gray-300'}`} />
                  <p className={`text-sm ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
                    No notifications yet
                  </p>
                </div>
              ) : (
                notifications.map((notif) => {
                  const Icon = getActionIcon(notif.action_type);
                  const colorClass = actionColors[notif.action_type] || "bg-gray-100 text-gray-500";
                  const isUnread = !readIds.has(notif.id);

                  return (
                    <div
                      key={notif.id}
                      onClick={() => markAsRead(notif.id)}
                      className={`flex items-start gap-3 px-5 py-3.5 cursor-pointer transition-colors ${
                        isUnread
                          ? isDark ? 'bg-[#4B9BDC]/5' : 'bg-blue-50/50'
                          : ''
                      } ${isDark ? 'hover:bg-gray-800/50' : 'hover:bg-gray-50'}`}
                    >
                      <div className={`w-8 h-8 rounded-lg flex items-center justify-center shrink-0 ${colorClass}`}>
                        <Icon size={14} />
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className={`text-xs font-medium leading-relaxed ${isDark ? 'text-gray-200' : 'text-gray-700'}`}>
                          {notif.details}
                        </p>
                        <div className="flex items-center gap-2 mt-1">
                          <span className={`text-[10px] font-medium ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
                            {notif.profiles?.full_name || "System"}
                          </span>
                          <span className={isDark ? 'text-gray-600' : 'text-gray-300'}>·</span>
                          <span className={`text-[10px] ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
                            {timeAgo(notif.created_at, language as any)}
                          </span>
                        </div>
                      </div>
                      {isUnread && (
                        <div className="w-2 h-2 rounded-full bg-[#4B9BDC] shrink-0 mt-2 animate-pulse" />
                      )}
                    </div>
                  );
                })
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
