import React, { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Wifi, WifiOff, Clock, Search, Command } from "lucide-react";
import { useTheme } from "../context/ThemeContext";
import { useLanguage } from "../context/LanguageContext";

export default function StatusBar() {
  const [isOnline, setIsOnline] = useState(navigator.onLine);
  const [currentTime, setCurrentTime] = useState(new Date());
  const { isDark } = useTheme();
  const { t } = useLanguage();

  // Track online/offline status
  useEffect(() => {
    const handleOnline = () => setIsOnline(true);
    const handleOffline = () => setIsOnline(false);
    window.addEventListener("online", handleOnline);
    window.addEventListener("offline", handleOffline);
    return () => {
      window.removeEventListener("online", handleOnline);
      window.removeEventListener("offline", handleOffline);
    };
  }, []);

  // Update clock every minute
  useEffect(() => {
    const interval = setInterval(() => setCurrentTime(new Date()), 60000);
    return () => clearInterval(interval);
  }, []);

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  const openCommandPalette = () => {
    // Dispatch a keyboard event to trigger Cmd+K
    const event = new KeyboardEvent('keydown', {
      key: 'k',
      metaKey: true,
      ctrlKey: true,
      bubbles: true,
    });
    window.dispatchEvent(event);
  };

  return (
    <div className="hidden lg:flex items-center gap-3">
      {/* Search Button (opens command palette) */}
      <button
        onClick={openCommandPalette}
        className={`flex items-center gap-2 px-3.5 py-2 rounded-xl text-sm transition-all ${
          isDark
            ? 'bg-gray-800/60 border border-gray-700/50 text-gray-400 hover:bg-gray-700/60 hover:text-gray-200'
            : 'bg-white border border-gray-200/80 text-gray-400 hover:bg-gray-50 hover:text-gray-600'
        } shadow-sm`}
      >
        <Search size={14} />
        <span className="font-medium text-xs">{t("common.search")}...</span>
        <kbd className={`ml-1 px-1.5 py-0.5 rounded-md text-[10px] font-bold border ${
          isDark
            ? 'bg-gray-700 border-gray-600 text-gray-400'
            : 'bg-gray-100 border-gray-200 text-gray-500'
        }`}>
          ⌘K
        </kbd>
      </button>

      {/* Connection Status */}
      <AnimatePresence mode="wait">
        <motion.div
          key={isOnline ? "online" : "offline"}
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          exit={{ scale: 0.8, opacity: 0 }}
          className={`flex items-center gap-1.5 px-3 py-2 rounded-xl text-xs font-semibold border shadow-sm ${
            isOnline
              ? isDark
                ? 'bg-emerald-900/20 border-emerald-800/30 text-emerald-400'
                : 'bg-emerald-50 border-emerald-100 text-emerald-600'
              : isDark
                ? 'bg-red-900/20 border-red-800/30 text-red-400'
                : 'bg-red-50 border-red-100 text-red-600'
          }`}
        >
          {isOnline ? (
            <>
              <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse" />
              <span>Online</span>
            </>
          ) : (
            <>
              <WifiOff size={12} />
              <span>Offline</span>
            </>
          )}
        </motion.div>
      </AnimatePresence>

      {/* Clock */}
      <div className={`flex items-center gap-1.5 px-3 py-2 rounded-xl text-xs font-bold tabular-nums border shadow-sm ${
        isDark
          ? 'bg-gray-800/60 border-gray-700/50 text-gray-400'
          : 'bg-white border-gray-200/80 text-gray-500'
      }`}>
        <Clock size={12} />
        {formatTime(currentTime)}
      </div>
    </div>
  );
}
