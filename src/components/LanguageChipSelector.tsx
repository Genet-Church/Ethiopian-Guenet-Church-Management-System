import React, { useState, useRef, useEffect, useMemo } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Plus, X, Search, Check, Globe, ChevronDown, Edit3 } from "lucide-react";
import { useTheme } from "../context/ThemeContext";
import { ds } from "../utils/darkStyles";

// Priority languages at top
const PRIORITY_LANGUAGES = ["አማርኛ", "Oromo", "ትግርኛ"];

const ALL_LANGUAGES = [
  // Priority first
  "አማርኛ", "Oromo", "ትግርኛ",
  // Alphabetical rest
  "Aari", "Afar", "Alaba", "Anfillo", "Anuak", "Arbore", "Argobba", "Awngi",
  "Baiso", "Bambassi", "Basketo", "Bench", "Berta", "Bodi", "Boro", "Burji", "Bussa",
  "Chaha", "Chara",
  "Daasanach", "Dawro", "Dime", "Dirasha", "Dizi", "Dorze",
  "Endegen", "Ezha",
  "Gamo", "Ganza", "Gawwada", "Gayil", "Gedeo", "Gofa", "Gumer", "Gumuz", "ጉራግኛ", "Gyeto",
  "Hadiyya", "Hamer-Banna", "Harari", "Hozo",
  "Inor",
  "Kachama-Ganjule", "Kafa", "Kambaata", "Karo", "Komo", "Konso", "Koore", "Kunama", "Kunfal", "Kwama", "Kwegu",
  "Libido",
  "Majang", "Male", "Me'en", "Melo", "Mesqan", "Muher", "Murle", "Mursi",
  "Nayi", "Nuer", "Nyangatom",
  "Ongota", "Opuuo", "Oyda",
  "Qimant",
  "Saho", "Seze", "Shabo", "Sheko", "Sidama", "Silt'e", "Soddo", "Somali", "Suri",
  "Tsamai",
  "Uduk",
  "Wolaytta",
  "Xamtanga",
  "Yemsa",
  "Zala", "Zay", "Zayse-Zergulla",
  "Other"
];

interface LanguageChipSelectorProps {
  value: string;
  onChange: (value: string) => void;
  label?: string;
  error?: string;
}

const LanguageChipSelector: React.FC<LanguageChipSelectorProps> = ({
  value,
  onChange,
  label,
  error,
}) => {
  const { isDark } = useTheme();
  const d = ds(isDark);
  const [isOpen, setIsOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [otherText, setOtherText] = useState("");
  const dropdownRef = useRef<HTMLDivElement>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);

  // Parse the comma-separated value into an array
  const selectedLanguages = useMemo(() => {
    if (!value || value.trim() === "") return [] as string[];
    return value.split(",").map((l: string) => l.trim()).filter(Boolean);
  }, [value]);

  // Check if "Other" is active (any custom language present)
  const hasOtherSelected = useMemo(() => {
    return selectedLanguages.some(
      (lang: string) => !ALL_LANGUAGES.includes(lang) || lang === "Other"
    );
  }, [selectedLanguages]);

  // Get custom languages (not in the predefined list)
  const customLanguages = useMemo(() => {
    return selectedLanguages.filter(
      (lang: string) => !ALL_LANGUAGES.includes(lang) && lang !== "Other"
    );
  }, [selectedLanguages]);

  // Close dropdown on outside click
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false);
        setSearchQuery("");
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // Focus search when dropdown opens
  useEffect(() => {
    if (isOpen && searchInputRef.current) {
      setTimeout(() => searchInputRef.current?.focus(), 100);
    }
  }, [isOpen]);

  const filteredLanguages = useMemo(() => {
    if (!searchQuery.trim()) return ALL_LANGUAGES;
    const query = searchQuery.toLowerCase();
    return ALL_LANGUAGES.filter((lang) =>
      lang.toLowerCase().includes(query)
    );
  }, [searchQuery]);

  // Group languages: priority first, then rest
  const groupedLanguages = useMemo(() => {
    const priority = filteredLanguages.filter((l) => PRIORITY_LANGUAGES.includes(l));
    const rest = filteredLanguages.filter(
      (l) => !PRIORITY_LANGUAGES.includes(l) && l !== "Other"
    );
    const other = filteredLanguages.includes("Other") ? ["Other"] : [];
    return { priority, rest, other };
  }, [filteredLanguages]);

  const toggleLanguage = (lang: string) => {
    if (lang === "Other") {
      // Don't add "Other" as a chip, just show the text field
      return;
    }

    const current = [...selectedLanguages];
    const idx = current.indexOf(lang);
    if (idx > -1) {
      current.splice(idx, 1);
    } else {
      current.push(lang);
    }
    // Remove the "Other" literal if it exists
    const filtered = current.filter((l) => l !== "Other");
    onChange(filtered.join(", "));
  };

  const removeLanguage = (lang: string) => {
    const filtered = selectedLanguages.filter((l: string) => l !== lang);
    onChange(filtered.join(", "));
  };

  const addCustomLanguage = () => {
    if (otherText.trim() && !selectedLanguages.includes(otherText.trim())) {
      const updated = [...selectedLanguages.filter((l: string) => l !== "Other"), otherText.trim()];
      onChange(updated.join(", "));
      setOtherText("");
    }
  };

  const handleOtherKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === "Enter") {
      e.preventDefault();
      addCustomLanguage();
    }
  };

  const isSelected = (lang: string) => selectedLanguages.includes(lang);

  const [showOtherInput, setShowOtherInput] = useState(false);

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Selected chips display */}
      <div
        className={`min-h-[56px] flex flex-wrap items-center gap-2 px-4 py-3 rounded-2xl border-2 transition-all duration-200 cursor-pointer ${isOpen
          ? "border-[#4B9BDC] ring-4 ring-[#4B9BDC]/10"
          : error
            ? "border-red-400 ring-2 ring-red-100"
            : "border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600"
          }`}
        style={d.searchBar(isOpen)}
        onClick={() => setIsOpen(true)}
      >
        <div className="flex items-center gap-1.5 mr-1">
          <Globe size={16} className="text-gray-400" />
        </div>

        {selectedLanguages.length === 0 ? (
          <span className="text-gray-400 text-sm font-medium select-none">
            Select languages...
          </span>
        ) : (
          <>
            <AnimatePresence mode="popLayout">
              {selectedLanguages.filter((l: string) => l !== "Other").map((lang: string) => (
                <motion.span
                  key={lang}
                  initial={{ opacity: 0, scale: 0.8 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.8 }}
                  transition={{ duration: 0.15 }}
                  className={`inline-flex items-center gap-1.5 pl-3 pr-1.5 py-1.5 rounded-xl text-xs font-bold transition-all ${PRIORITY_LANGUAGES.includes(lang)
                    ? "bg-gradient-to-r from-[#4B9BDC]/15 to-[#7EC8F2]/15 text-[#4B9BDC] border border-[#4B9BDC]/20"
                    : ALL_LANGUAGES.includes(lang)
                      ? isDark
                        ? "bg-gray-700/60 text-gray-200 border border-gray-600/50"
                        : "bg-gray-100 text-gray-700 border border-gray-200/80"
                      : isDark
                        ? "bg-purple-900/30 text-purple-300 border border-purple-700/30"
                        : "bg-purple-50 text-purple-700 border border-purple-200/80"
                    }`}
                >
                  {lang}
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      removeLanguage(lang);
                    }}
                    className={`p-0.5 rounded-lg transition-colors ${isDark
                      ? "hover:bg-white/10"
                      : "hover:bg-black/10"
                      }`}
                  >
                    <X size={12} />
                  </button>
                </motion.span>
              ))}
            </AnimatePresence>
          </>
        )}

        <button
          type="button"
          onClick={(e) => {
            e.stopPropagation();
            setIsOpen(!isOpen);
          }}
          className="ml-auto flex items-center gap-1 pl-2 pr-1 py-1 rounded-lg bg-gradient-to-r from-[#4B9BDC] to-[#7EC8F2] text-white text-[10px] font-bold hover:shadow-md transition-all hover:scale-105 shrink-0"
        >
          <Plus size={12} />
          <ChevronDown
            size={12}
            className={`transition-transform duration-200 ${isOpen ? "rotate-180" : ""}`}
          />
        </button>
      </div>

      {error && (
        <p className="form-error mt-1 text-xs text-red-500">{error}</p>
      )}

      {/* Dropdown */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 8, scale: 0.96 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 8, scale: 0.96 }}
            transition={{ duration: 0.15, ease: "easeOut" }}
            className={`absolute left-0 right-0 top-full mt-2 z-50 rounded-2xl border shadow-[0_20px_60px_rgba(0,0,0,0.15)] overflow-hidden ${isDark
              ? "bg-gray-900/98 border-gray-700/50 backdrop-blur-xl"
              : "bg-white/98 border-gray-200/50 backdrop-blur-xl"
              }`}
          >
            {/* Search bar */}
            <div className="p-3 border-b border-gray-100 dark:border-gray-800">
              <div
                className={`flex items-center gap-2.5 px-4 py-3 rounded-xl border transition-all ${isDark
                  ? "bg-gray-800/60 border-gray-700/50"
                  : "bg-gray-50 border-gray-100"
                  }`}
              >
                <Search size={16} className="text-gray-400 shrink-0" />
                <input
                  ref={searchInputRef}
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search languages..."
                  className={`w-full bg-transparent text-sm font-medium outline-none placeholder:text-gray-400 ${isDark ? "text-gray-200" : "text-gray-700"
                    }`}
                />
                {searchQuery && (
                  <button
                    type="button"
                    onClick={() => setSearchQuery("")}
                    className="p-0.5 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                  >
                    <X size={14} className="text-gray-400" />
                  </button>
                )}
              </div>
            </div>

            {/* Language options */}
            <div className="max-h-[280px] overflow-y-auto custom-scrollbar p-2">
              {/* Priority languages at top */}
              {groupedLanguages.priority.length > 0 && (
                <>
                  {groupedLanguages.priority.map((lang) => (
                    <LanguageOption
                      key={lang}
                      lang={lang}
                      isSelected={isSelected(lang)}
                      isPriority={false}
                      onToggle={() => toggleLanguage(lang)}
                      isDark={isDark}
                    />
                  ))}
                  {(groupedLanguages.rest.length > 0 || groupedLanguages.other.length > 0) && (
                    <div className={`h-px mx-3 my-1.5 ${isDark ? "bg-gray-800" : "bg-gray-100"}`} />
                  )}
                </>
              )}

              {/* Rest of languages */}
              {groupedLanguages.rest.length > 0 && (
                <>
                  {groupedLanguages.rest.map((lang) => (
                    <LanguageOption
                      key={lang}
                      lang={lang}
                      isSelected={isSelected(lang)}
                      isPriority={false}
                      onToggle={() => toggleLanguage(lang)}
                      isDark={isDark}
                    />
                  ))}
                </>
              )}

              {/* Other option */}
              {groupedLanguages.other.length > 0 && (
                <>
                  <div className={`h-px mx-3 my-1.5 ${isDark ? "bg-gray-800" : "bg-gray-100"}`} />
                  <button
                    type="button"
                    onClick={() => setShowOtherInput(!showOtherInput)}
                    className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-left transition-all ${showOtherInput
                      ? isDark
                        ? "bg-purple-900/30 text-purple-300"
                        : "bg-purple-50 text-purple-700"
                      : isDark
                        ? "hover:bg-gray-800 text-gray-300"
                        : "hover:bg-gray-50 text-gray-600"
                      }`}
                  >
                    <div
                      className={`w-8 h-8 rounded-lg flex items-center justify-center transition-all ${showOtherInput
                        ? "bg-purple-500/20 text-purple-500"
                        : isDark
                          ? "bg-gray-800 text-gray-500"
                          : "bg-gray-100 text-gray-400"
                        }`}
                    >
                      <Edit3 size={14} />
                    </div>
                    <span className="text-sm font-semibold">Other</span>
                    <span className={`text-[10px] font-medium ${isDark ? "text-gray-500" : "text-gray-400"
                      }`}>
                      — type a custom language
                    </span>
                  </button>

                  {/* "Other" text input */}
                  <AnimatePresence>
                    {showOtherInput && (
                      <motion.div
                        initial={{ opacity: 0, height: 0 }}
                        animate={{ opacity: 1, height: "auto" }}
                        exit={{ opacity: 0, height: 0 }}
                        transition={{ duration: 0.15 }}
                        className="overflow-hidden"
                      >
                        <div className="px-3 py-2 flex items-center gap-2">
                          <input
                            type="text"
                            value={otherText}
                            onChange={(e) => setOtherText(e.target.value)}
                            onKeyDown={handleOtherKeyDown}
                            placeholder="Type language name..."
                            className={`flex-1 px-4 py-2.5 rounded-xl text-sm font-medium outline-none border-2 transition-all ${isDark
                              ? "bg-gray-800/60 border-gray-700 text-gray-200 placeholder:text-gray-500 focus:border-purple-500 focus:ring-2 focus:ring-purple-500/20"
                              : "bg-gray-50 border-gray-200 text-gray-700 placeholder:text-gray-400 focus:border-purple-400 focus:ring-2 focus:ring-purple-400/20"
                              }`}
                          />
                          <button
                            type="button"
                            onClick={addCustomLanguage}
                            disabled={!otherText.trim()}
                            className={`px-4 py-2.5 rounded-xl text-xs font-bold transition-all ${otherText.trim()
                              ? "bg-gradient-to-r from-purple-500 to-pink-500 text-white hover:shadow-lg hover:scale-105"
                              : isDark
                                ? "bg-gray-800 text-gray-600 cursor-not-allowed"
                                : "bg-gray-100 text-gray-400 cursor-not-allowed"
                              }`}
                          >
                            <Plus size={16} />
                          </button>
                        </div>

                        {/* Show custom languages already added */}
                        {customLanguages.length > 0 && (
                          <div className="px-3 pb-2 flex flex-wrap gap-1.5">
                            {customLanguages.map((lang: string) => (
                              <span
                                key={lang}
                                className={`inline-flex items-center gap-1 pl-2.5 pr-1 py-1 rounded-lg text-[11px] font-bold ${isDark
                                  ? "bg-purple-900/30 text-purple-300 border border-purple-700/30"
                                  : "bg-purple-50 text-purple-600 border border-purple-200"
                                  }`}
                              >
                                {lang}
                                <button
                                  type="button"
                                  onClick={() => removeLanguage(lang)}
                                  className="p-0.5 rounded hover:bg-purple-200/30 transition-colors"
                                >
                                  <X size={10} />
                                </button>
                              </span>
                            ))}
                          </div>
                        )}
                      </motion.div>
                    )}
                  </AnimatePresence>
                </>
              )}

              {/* No results */}
              {filteredLanguages.length === 0 && (
                <div className="py-8 text-center">
                  <Globe size={24} className="mx-auto mb-2 text-gray-300 dark:text-gray-600" />
                  <p className={`text-sm font-medium ${isDark ? "text-gray-500" : "text-gray-400"}`}>
                    No languages found
                  </p>
                  <p className={`text-xs mt-1 ${isDark ? "text-gray-600" : "text-gray-300"}`}>
                    Try "Other" to add a custom language
                  </p>
                </div>
              )}
            </div>

            {/* Footer with count */}
            {selectedLanguages.filter((l: string) => l !== "Other").length > 0 && (
              <div
                className={`px-4 py-2.5 border-t flex items-center justify-between ${isDark ? "border-gray-800 bg-gray-900/50" : "border-gray-100 bg-gray-50/50"
                  }`}
              >
                <span className={`text-[11px] font-bold ${isDark ? "text-gray-400" : "text-gray-500"}`}>
                  {selectedLanguages.filter((l: string) => l !== "Other").length} language{selectedLanguages.filter((l: string) => l !== "Other").length !== 1 ? "s" : ""} selected
                </span>
                <button
                  type="button"
                  onClick={() => {
                    setIsOpen(false);
                    setSearchQuery("");
                  }}
                  className="text-[11px] font-bold text-[#4B9BDC] hover:text-[#3a8bcb] transition-colors"
                >
                  Done
                </button>
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

// Individual language option row
interface LanguageOptionProps {
  lang: string;
  isSelected: boolean;
  isPriority: boolean;
  onToggle: () => void;
  isDark: boolean;
}

const LanguageOption: React.FC<LanguageOptionProps> = ({
  lang,
  isSelected,
  isPriority,
  onToggle,
  isDark,
}) => {
  return (
    <button
      type="button"
      onClick={onToggle}
      className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-left transition-all mb-0.5 ${isSelected
        ? isPriority
          ? "bg-[#4B9BDC]/10 text-[#4B9BDC]"
          : isDark
            ? "bg-blue-900/20 text-blue-300"
            : "bg-blue-50 text-blue-700"
        : isDark
          ? "hover:bg-gray-800 text-gray-300"
          : "hover:bg-gray-50 text-gray-600"
        }`}
    >
      {/* Checkbox */}
      <div
        className={`w-5 h-5 rounded-md border-2 flex items-center justify-center transition-all shrink-0 ${isSelected
          ? "bg-[#4B9BDC] border-[#4B9BDC] text-white scale-105"
          : isDark
            ? "border-gray-600 bg-gray-800"
            : "border-gray-300 bg-white"
          }`}
      >
        {isSelected && (
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ type: "spring", stiffness: 500, damping: 30 }}
          >
            <Check size={12} strokeWidth={3} />
          </motion.div>
        )}
      </div>

      {/* Language name */}
      <div className="flex items-center gap-2 flex-1 min-w-0">
        <span className="text-sm font-semibold truncate">
          {lang}
        </span>
      </div>
    </button>
  );
};

export default LanguageChipSelector;
