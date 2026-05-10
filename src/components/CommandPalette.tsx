import React, { useState, useEffect, useCallback, useRef, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import {
  Search, LayoutDashboard, Building, Users, Shield, Layers,
  Calendar, FileBarChart, Settings, UserCheck, ShieldCheck,
  ArrowRight, Command, Hash, CornerDownLeft, X
} from "lucide-react";
import { useAuth } from "../context/AuthContext";
import { useLanguage } from "../context/LanguageContext";
import { useTheme } from "../context/ThemeContext";
import { supabase } from "../supabaseClient";

interface SearchResult {
  id: string;
  type: "page" | "member" | "church" | "department" | "action";
  title: string;
  subtitle?: string;
  icon: React.ComponentType<any>;
  path?: string;
  action?: () => void;
}

export default function CommandPalette() {
  const [isOpen, setIsOpen] = useState(false);
  const [query, setQuery] = useState("");
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [members, setMembers] = useState<any[]>([]);
  const [churches, setChurches] = useState<any[]>([]);
  const [departments, setDepartments] = useState<any[]>([]);
  const [recentSearches, setRecentSearches] = useState<string[]>([]);
  const inputRef = useRef<HTMLInputElement>(null);
  const listRef = useRef<HTMLDivElement>(null);

  const navigate = useNavigate();
  const { profile } = useAuth();
  const { t } = useLanguage();
  const { isDark } = useTheme();

  // Load recent searches from localStorage
  useEffect(() => {
    const saved = localStorage.getItem("guenet-recent-searches");
    if (saved) {
      try { setRecentSearches(JSON.parse(saved)); } catch { }
    }
  }, []);

  // Keyboard shortcut to open
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === "k") {
        e.preventDefault();
        setIsOpen(prev => !prev);
      }
      if (e.key === "Escape") {
        setIsOpen(false);
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, []);

  // Focus input when opened
  useEffect(() => {
    if (isOpen) {
      setTimeout(() => inputRef.current?.focus(), 100);
      setQuery("");
      setSelectedIndex(0);
      fetchData();
    }
  }, [isOpen]);

  const fetchData = async () => {
    try {
      const [membersRes, churchesRes, deptsRes] = await Promise.all([
        supabase.from("members").select("id, full_name, phone, church_id").limit(100),
        supabase.from("churches").select("id, name, location").limit(50),
        supabase.from("departments").select("id, name, church_id").limit(50),
      ]);
      if (membersRes.data) setMembers(membersRes.data);
      if (churchesRes.data) setChurches(churchesRes.data);
      if (deptsRes.data) setDepartments(deptsRes.data);
    } catch (err) {
      console.error("Error fetching command palette data:", err);
    }
  };

  // Build navigation pages
  const pages: SearchResult[] = useMemo(() => {
    const allPages: SearchResult[] = [
      { id: "page-dashboard", type: "page", title: t("sidebar.dashboard"), icon: LayoutDashboard, path: "/" },
      { id: "page-members", type: "page", title: t("sidebar.members"), icon: Users, path: "/members" },
      { id: "page-departments", type: "page", title: t("sidebar.departments"), icon: Layers, path: "/departments" },
      { id: "page-activities", type: "page", title: t("sidebar.activities"), icon: Calendar, path: "/activities" },
      { id: "page-settings", type: "page", title: t("sidebar.settings"), icon: Settings, path: "/settings" },
    ];

    if (profile?.role === "super_admin") {
      allPages.push(
        { id: "page-churches", type: "page", title: t("sidebar.churches"), icon: Building, path: "/churches" },
        { id: "page-admins", type: "page", title: t("sidebar.admins"), icon: UserCheck, path: "/admins" },
      );
    }

    if (profile?.role === "super_admin" || profile?.role === "admin") {
      allPages.push(
        { id: "page-servants", type: "page", title: t("sidebar.servants"), icon: ShieldCheck, path: "/servants" },
        { id: "page-reports", type: "page", title: t("sidebar.reports"), icon: FileBarChart, path: "/reports" },
      );
    }

    return allPages;
  }, [profile, t]);

  // Actions
  const actions: SearchResult[] = useMemo(() => [
    {
      id: "action-add-member",
      type: "action",
      title: t("members.addBtn"),
      subtitle: t("dashboard.actions.viewAddMembers"),
      icon: Users,
      path: "/members/add",
    },
  ], [t]);

  // Filter results
  const results = useMemo(() => {
    const q = query.toLowerCase().trim();
    if (!q) {
      return [
        ...pages.slice(0, 5),
        ...actions,
      ];
    }

    const filtered: SearchResult[] = [];

    // Filter pages
    pages.forEach(p => {
      if (p.title.toLowerCase().includes(q)) {
        filtered.push(p);
      }
    });

    // Filter actions
    actions.forEach(a => {
      if (a.title.toLowerCase().includes(q) || a.subtitle?.toLowerCase().includes(q)) {
        filtered.push(a);
      }
    });

    // Filter members
    members.forEach(m => {
      if (m.full_name?.toLowerCase().includes(q) || m.phone?.includes(q)) {
        filtered.push({
          id: `member-${m.id}`,
          type: "member",
          title: m.full_name || "Unknown",
          subtitle: m.phone || "",
          icon: Users,
          path: `/members/${m.id}`,
        });
      }
    });

    // Filter churches
    churches.forEach(c => {
      if (c.name?.toLowerCase().includes(q) || c.location?.toLowerCase().includes(q)) {
        filtered.push({
          id: `church-${c.id}`,
          type: "church",
          title: c.name,
          subtitle: c.location || "",
          icon: Building,
          path: "/churches",
        });
      }
    });

    // Filter departments
    departments.forEach(d => {
      if (d.name?.toLowerCase().includes(q)) {
        filtered.push({
          id: `dept-${d.id}`,
          type: "department",
          title: d.name,
          subtitle: t("sidebar.departments"),
          icon: Layers,
          path: `/departments/${d.id}`,
        });
      }
    });

    return filtered.slice(0, 12);
  }, [query, pages, actions, members, churches, departments, t]);

  // Reset selection when results change
  useEffect(() => {
    setSelectedIndex(0);
  }, [results.length]);

  // Handle selection
  const handleSelect = useCallback((result: SearchResult) => {
    if (result.action) {
      result.action();
    } else if (result.path) {
      navigate(result.path);
    }

    // Save to recent searches
    if (query.trim()) {
      const updated = [query, ...recentSearches.filter(s => s !== query)].slice(0, 5);
      setRecentSearches(updated);
      localStorage.setItem("guenet-recent-searches", JSON.stringify(updated));
    }

    setIsOpen(false);
    setQuery("");
  }, [navigate, query, recentSearches]);

  // Keyboard navigation
  const handleKeyDown = useCallback((e: React.KeyboardEvent) => {
    if (e.key === "ArrowDown") {
      e.preventDefault();
      setSelectedIndex(prev => Math.min(prev + 1, results.length - 1));
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      setSelectedIndex(prev => Math.max(prev - 1, 0));
    } else if (e.key === "Enter") {
      e.preventDefault();
      if (results[selectedIndex]) {
        handleSelect(results[selectedIndex]);
      }
    }
  }, [results, selectedIndex, handleSelect]);

  // Scroll selected item into view
  useEffect(() => {
    if (listRef.current) {
      const el = listRef.current.children[selectedIndex] as HTMLElement;
      if (el) {
        el.scrollIntoView({ block: "nearest" });
      }
    }
  }, [selectedIndex]);

  const getTypeLabel = (type: string) => {
    switch (type) {
      case "page": return "Page";
      case "member": return "Member";
      case "church": return "Church";
      case "department": return "Dept";
      case "action": return "Action";
      default: return "";
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case "page": return "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-300";
      case "member": return "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-300";
      case "church": return "bg-violet-100 text-violet-700 dark:bg-violet-900/30 dark:text-violet-300";
      case "department": return "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-300";
      case "action": return "bg-rose-100 text-rose-700 dark:bg-rose-900/30 dark:text-rose-300";
      default: return "bg-gray-100 text-gray-600";
    }
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.15 }}
          className="fixed inset-0 z-[9999] flex items-start justify-center pt-[15vh]"
          onClick={() => setIsOpen(false)}
        >
          {/* Backdrop */}
          <div className={`absolute inset-0 ${isDark ? 'bg-black/70' : 'bg-black/40'} backdrop-blur-sm`} />

          {/* Palette */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95, y: -20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: -20 }}
            transition={{ type: "spring", stiffness: 400, damping: 30 }}
            onClick={(e) => e.stopPropagation()}
            className={`relative w-[95vw] max-w-[640px] rounded-2xl overflow-hidden shadow-2xl border ${
              isDark
                ? 'bg-gray-900/95 border-gray-700/60'
                : 'bg-white/95 border-gray-200/80'
            } backdrop-blur-2xl`}
            style={{
              boxShadow: isDark
                ? '0 25px 60px rgba(0,0,0,0.6), 0 0 0 1px rgba(255,255,255,0.05)'
                : '0 25px 60px rgba(0,0,0,0.15), 0 0 0 1px rgba(255,255,255,0.8)',
            }}
          >
            {/* Search Input */}
            <div className={`flex items-center gap-3 px-5 py-4 border-b ${isDark ? 'border-gray-700/50' : 'border-gray-200/60'}`}>
              <Search size={20} className={`shrink-0 ${isDark ? 'text-gray-400' : 'text-gray-400'}`} />
              <input
                ref={inputRef}
                type="text"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder={t("common.search") + "..."}
                className={`flex-1 bg-transparent text-base font-medium outline-none placeholder:text-gray-400 ${
                  isDark ? 'text-gray-100' : 'text-gray-900'
                }`}
                style={{ border: 'none', boxShadow: 'none' }}
              />
              <div className="flex items-center gap-1.5 shrink-0">
                <kbd className={`px-1.5 py-0.5 rounded-md text-[10px] font-bold border ${
                  isDark
                    ? 'bg-gray-800 border-gray-700 text-gray-400'
                    : 'bg-gray-100 border-gray-200 text-gray-500'
                }`}>ESC</kbd>
              </div>
            </div>

            {/* Results */}
            <div
              ref={listRef}
              className="max-h-[360px] overflow-y-auto py-2 px-2 custom-scrollbar"
            >
              {results.length === 0 ? (
                <div className="py-12 text-center">
                  <Search size={32} className="mx-auto mb-3 text-gray-300 dark:text-gray-600" />
                  <p className={`text-sm font-medium ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                    {t("common.tryAdjusting")}
                  </p>
                </div>
              ) : (
                results.map((result, index) => (
                  <button
                    key={result.id}
                    onClick={() => handleSelect(result)}
                    className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-left transition-all duration-100 group ${
                      index === selectedIndex
                        ? isDark
                          ? 'bg-[#4B9BDC]/15 text-white'
                          : 'bg-[#4B9BDC]/10 text-gray-900'
                        : isDark
                          ? 'text-gray-300 hover:bg-gray-800/50'
                          : 'text-gray-700 hover:bg-gray-50'
                    }`}
                  >
                    <div className={`w-9 h-9 rounded-lg flex items-center justify-center shrink-0 transition-all ${
                      index === selectedIndex
                        ? 'bg-[#4B9BDC] text-white shadow-md'
                        : isDark ? 'bg-gray-800 text-gray-400' : 'bg-gray-100 text-gray-500'
                    }`}>
                      <result.icon size={16} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className={`text-sm font-semibold truncate ${
                        index === selectedIndex ? (isDark ? 'text-white' : 'text-gray-900') : ''
                      }`}>
                        {result.title}
                      </p>
                      {result.subtitle && (
                        <p className={`text-xs truncate ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
                          {result.subtitle}
                        </p>
                      )}
                    </div>
                    <span className={`text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-md shrink-0 ${getTypeColor(result.type)}`}>
                      {getTypeLabel(result.type)}
                    </span>
                    {index === selectedIndex && (
                      <CornerDownLeft size={14} className={isDark ? 'text-gray-500' : 'text-gray-400'} />
                    )}
                  </button>
                ))
              )}
            </div>

            {/* Footer */}
            <div className={`flex items-center justify-between px-5 py-3 border-t ${isDark ? 'border-gray-700/50' : 'border-gray-200/60'}`}>
              <div className="flex items-center gap-3 text-xs text-gray-400">
                <span className="flex items-center gap-1">
                  <kbd className={`px-1 py-0.5 rounded text-[9px] font-bold border ${isDark ? 'bg-gray-800 border-gray-700' : 'bg-gray-100 border-gray-200'}`}>↑↓</kbd>
                  Navigate
                </span>
                <span className="flex items-center gap-1">
                  <kbd className={`px-1 py-0.5 rounded text-[9px] font-bold border ${isDark ? 'bg-gray-800 border-gray-700' : 'bg-gray-100 border-gray-200'}`}>↵</kbd>
                  Select
                </span>
              </div>
              <span className={`text-xs font-medium ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
                {results.length} results
              </span>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
