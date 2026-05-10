import React, { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Sun, Moon, Sunset, Coffee, X, Sparkles } from "lucide-react";
import { useAuth } from "../context/AuthContext";
import { useLanguage } from "../context/LanguageContext";
import { useTheme } from "../context/ThemeContext";

const verses = [
  "\"For I know the plans I have for you,\" declares the LORD. — Jeremiah 29:11",
  "\"The LORD is my shepherd; I shall not want.\" — Psalm 23:1",
  "\"I can do all things through Christ who strengthens me.\" — Philippians 4:13",
  "\"Trust in the LORD with all your heart.\" — Proverbs 3:5",
  "\"Be strong and courageous. Do not be afraid.\" — Joshua 1:9",
  "\"The joy of the LORD is your strength.\" — Nehemiah 8:10",
  "\"God is our refuge and strength, a very present help in trouble.\" — Psalm 46:1",
  "\"Come to me, all who labor and are heavy laden, and I will give you rest.\" — Matthew 11:28",
];

export default function WelcomeGreeting() {
  const [visible, setVisible] = useState(false);
  const [verse, setVerse] = useState("");
  const { profile } = useAuth();
  const { t } = useLanguage();
  const { isDark } = useTheme();

  useEffect(() => {
    // Show greeting only once per session
    const sessionKey = `guenet-greeted-${new Date().toDateString()}`;
    const alreadyGreeted = sessionStorage.getItem(sessionKey);

    if (!alreadyGreeted && profile) {
      setVisible(true);
      sessionStorage.setItem(sessionKey, "true");
      setVerse(verses[Math.floor(Math.random() * verses.length)]);

      // Auto-dismiss after 8 seconds
      const timer = setTimeout(() => setVisible(false), 8000);
      return () => clearTimeout(timer);
    }
  }, [profile]);

  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return { text: "Good Morning", icon: Coffee, gradient: "from-amber-400 to-orange-500" };
    if (hour < 17) return { text: "Good Afternoon", icon: Sun, gradient: "from-sky-400 to-blue-500" };
    if (hour < 21) return { text: "Good Evening", icon: Sunset, gradient: "from-violet-400 to-purple-500" };
    return { text: "Good Night", icon: Moon, gradient: "from-indigo-400 to-slate-600" };
  };

  const greeting = getGreeting();
  const firstName = profile?.full_name?.split(" ")[0] || t("common.user");

  return (
    <AnimatePresence>
      {visible && (
        <motion.div
          initial={{ opacity: 0, y: -20, scale: 0.98 }}
          animate={{ opacity: 1, y: 0, scale: 1 }}
          exit={{ opacity: 0, y: -20, scale: 0.98 }}
          transition={{ type: "spring", stiffness: 300, damping: 25 }}
          className={`relative overflow-hidden rounded-2xl mb-6 ${
            isDark
              ? 'bg-gradient-to-r from-gray-800/80 to-gray-900/80 border border-gray-700/50'
              : 'bg-gradient-to-r from-white/90 to-blue-50/90 border border-blue-100/50'
          } backdrop-blur-xl shadow-lg`}
        >
          {/* Decorative gradient strip */}
          <div className={`absolute top-0 left-0 right-0 h-1 bg-gradient-to-r ${greeting.gradient}`} />

          {/* Animated sparkle */}
          <motion.div
            animate={{ rotate: [0, 360] }}
            transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
            className="absolute top-3 right-16 opacity-10"
          >
            <Sparkles size={60} />
          </motion.div>

          <div className="relative z-10 flex items-center justify-between px-5 py-4">
            <div className="flex items-center gap-4">
              <motion.div
                initial={{ scale: 0, rotate: -180 }}
                animate={{ scale: 1, rotate: 0 }}
                transition={{ type: "spring", delay: 0.2, stiffness: 200 }}
                className={`w-11 h-11 rounded-xl bg-gradient-to-br ${greeting.gradient} flex items-center justify-center text-white shadow-lg`}
              >
                <greeting.icon size={20} />
              </motion.div>
              <div>
                <motion.h2
                  initial={{ opacity: 0, x: -10 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.15 }}
                  className={`text-base font-bold ${isDark ? 'text-gray-100' : 'text-gray-900'}`}
                >
                  {greeting.text}, {firstName}! 👋
                </motion.h2>
                <motion.p
                  initial={{ opacity: 0, x: -10 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.25 }}
                  className={`text-xs font-medium mt-0.5 max-w-md ${isDark ? 'text-gray-400' : 'text-gray-500'}`}
                >
                  {verse}
                </motion.p>
              </div>
            </div>

            <button
              onClick={() => setVisible(false)}
              className={`p-1.5 rounded-lg transition-colors shrink-0 ${
                isDark ? 'hover:bg-gray-700 text-gray-500' : 'hover:bg-gray-100 text-gray-400'
              }`}
            >
              <X size={14} />
            </button>
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
