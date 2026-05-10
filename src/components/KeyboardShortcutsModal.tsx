import React, { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Keyboard, X, Command, ArrowUp, ArrowDown, CornerDownLeft, Search } from "lucide-react";
import { useTheme } from "../context/ThemeContext";

interface Shortcut {
  keys: string[];
  description: string;
  category: string;
}

const shortcuts: Shortcut[] = [
  { keys: ["⌘", "K"], description: "Open Command Palette", category: "Navigation" },
  { keys: ["?"], description: "Show Keyboard Shortcuts", category: "Navigation" },
  { keys: ["ESC"], description: "Close dialogs & menus", category: "Navigation" },
  { keys: ["↑", "↓"], description: "Navigate items in lists", category: "Navigation" },
  { keys: ["↵"], description: "Select item / Confirm action", category: "Navigation" },
  { keys: ["⌘", "D"], description: "Go to Dashboard", category: "Quick Actions" },
  { keys: ["⌘", "M"], description: "Go to Members", category: "Quick Actions" },
];

export default function KeyboardShortcutsModal() {
  const [isOpen, setIsOpen] = useState(false);
  const { isDark } = useTheme();

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Open on "?" key press, but not when typing in inputs
      if (e.key === "?" && !["INPUT", "TEXTAREA", "SELECT"].includes((e.target as HTMLElement).tagName)) {
        e.preventDefault();
        setIsOpen(prev => !prev);
      }
      if (e.key === "Escape" && isOpen) {
        setIsOpen(false);
      }

      // Quick nav shortcuts
      if (e.metaKey || e.ctrlKey) {
        switch (e.key.toLowerCase()) {
          case "d":
            e.preventDefault();
            window.location.hash = "#/";
            break;
          case "m":
            e.preventDefault();
            window.location.hash = "#/members";
            break;
        }
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [isOpen]);

  const categories = [...new Set(shortcuts.map(s => s.category))];

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.15 }}
          className="fixed inset-0 z-[9998] flex items-center justify-center"
          onClick={() => setIsOpen(false)}
        >
          <div className={`absolute inset-0 ${isDark ? 'bg-black/60' : 'bg-black/30'} backdrop-blur-sm`} />

          <motion.div
            initial={{ opacity: 0, scale: 0.95, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: 20 }}
            transition={{ type: "spring", stiffness: 400, damping: 30 }}
            onClick={(e) => e.stopPropagation()}
            className={`relative w-[90vw] max-w-[520px] rounded-2xl overflow-hidden shadow-2xl border ${
              isDark
                ? 'bg-gray-900/95 border-gray-700/60'
                : 'bg-white/95 border-gray-200/80'
            } backdrop-blur-2xl`}
          >
            {/* Header */}
            <div className={`flex items-center justify-between px-6 py-4 border-b ${isDark ? 'border-gray-700/50' : 'border-gray-200/60'}`}>
              <div className="flex items-center gap-3">
                <div className={`w-9 h-9 rounded-xl flex items-center justify-center ${isDark ? 'bg-gray-800 text-gray-400' : 'bg-gray-100 text-gray-500'}`}>
                  <Keyboard size={18} />
                </div>
                <div>
                  <h2 className={`text-sm font-bold ${isDark ? 'text-gray-100' : 'text-gray-900'}`}>Keyboard Shortcuts</h2>
                  <p className={`text-xs ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>Navigate faster with shortcuts</p>
                </div>
              </div>
              <button
                onClick={() => setIsOpen(false)}
                className={`p-2 rounded-xl ${isDark ? 'hover:bg-gray-800 text-gray-500' : 'hover:bg-gray-100 text-gray-400'}`}
              >
                <X size={16} />
              </button>
            </div>

            {/* Shortcuts List */}
            <div className="p-5 space-y-6 max-h-[60vh] overflow-y-auto custom-scrollbar">
              {categories.map(category => (
                <div key={category}>
                  <h3 className={`text-[10px] font-bold uppercase tracking-wider mb-3 ${isDark ? 'text-gray-500' : 'text-gray-400'}`}>
                    {category}
                  </h3>
                  <div className="space-y-2">
                    {shortcuts.filter(s => s.category === category).map((shortcut, i) => (
                      <div
                        key={i}
                        className={`flex items-center justify-between py-2.5 px-3 rounded-xl ${isDark ? 'hover:bg-gray-800/50' : 'hover:bg-gray-50'}`}
                      >
                        <span className={`text-sm font-medium ${isDark ? 'text-gray-300' : 'text-gray-700'}`}>
                          {shortcut.description}
                        </span>
                        <div className="flex items-center gap-1">
                          {shortcut.keys.map((key, j) => (
                            <React.Fragment key={j}>
                              {j > 0 && <span className={`text-xs ${isDark ? 'text-gray-600' : 'text-gray-300'}`}>+</span>}
                              <kbd className={`min-w-[26px] h-7 px-2 rounded-lg text-xs font-bold flex items-center justify-center border shadow-sm ${
                                isDark
                                  ? 'bg-gray-800 border-gray-700 text-gray-300'
                                  : 'bg-gray-100 border-gray-200 text-gray-600'
                              }`}>
                                {key}
                              </kbd>
                            </React.Fragment>
                          ))}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>

            {/* Footer */}
            <div className={`px-6 py-3 border-t text-center ${isDark ? 'border-gray-700/50' : 'border-gray-200/60'}`}>
              <p className={`text-xs ${isDark ? 'text-gray-600' : 'text-gray-400'}`}>
                Press <kbd className={`px-1.5 py-0.5 rounded-md text-[10px] font-bold border mx-0.5 ${isDark ? 'bg-gray-800 border-gray-700 text-gray-400' : 'bg-gray-100 border-gray-200 text-gray-500'}`}>?</kbd> anytime to toggle this dialog
              </p>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
