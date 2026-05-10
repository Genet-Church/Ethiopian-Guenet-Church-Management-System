import React, { useState, useEffect, useRef } from "react";
import { Calendar as CalendarIcon, ChevronLeft, ChevronRight, X } from "lucide-react";
import { useAuth } from "../../context/AuthContext";
import { useLanguage } from "../../context/LanguageContext";
import { EthDateTime } from "ethiopian-calendar-date-converter";
import { motion, AnimatePresence } from "framer-motion";
import { formatDisplayDate } from "../../utils/dateFormatter";

interface DatePickerProps {
  value: Date | null;
  onChange: (date: Date | null) => void;
  placeholder?: string;
  className?: string;
}

const AM_MONTHS_ETH = [
  "መስከረም", "ጥቅምት", "ኅዳር", "ታኅሣሥ", "ጥር", "የካቲት", "መጋቢት", "ሚያዝያ", "ግንቦት", "ሰኔ", "ሐምሌ", "ነሐሴ", "ጳጉሜ",
];

const EN_MONTHS_ETH = [
  "Meskerem", "Tikimt", "Hidar", "Tahsas", "Tir", "Yekatit", "Megabit", "Miyazya", "Ginbot", "Sene", "Hamle", "Nehasse", "Pagume",
];

const GREG_MONTHS_EN = [
  "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December",
];

const GREG_MONTHS_AM = [
  "ጃንዋሪ", "ፌብሩዋሪ", "ማርች", "ኤፕሪል", "ሜይ", "ጁን", "ጁላይ", "ኦገስት", "ሴፕቴምበር", "ኦክቶበር", "ኖቬምበር", "ዲሴምበር",
];

const WEEKDAYS_EN = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
const WEEKDAYS_AM = ["እሑድ", "ሰኞ", "ማክሰ", "ረቡዕ", "ሐሙስ", "አርብ", "ቅዳሜ"];

export default function DatePicker({ value, onChange, placeholder = "Select Date", className = "" }: DatePickerProps) {
  const { calendarType } = useAuth();
  const { t, language } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  // View state
  const [viewDate, setViewDate] = useState<Date>(value || new Date());
  
  // Ethiopian view state
  const [ethYear, setEthYear] = useState<number>(new Date().getFullYear());
  const [ethMonth, setEthMonth] = useState<number>(1);

  useEffect(() => {
    if (calendarType === "ethiopian") {
      try {
        const ethDate = EthDateTime.fromEuropeanDate(value || new Date());
        setEthYear(ethDate.year);
        setEthMonth(ethDate.month);
      } catch (e) {
        console.error(e);
      }
    } else {
      setViewDate(value || new Date());
    }
  }, [value, calendarType]);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // Gregorian helpers
  const getDaysInMonth = (year: number, month: number) => new Date(year, month + 1, 0).getDate();
  const getFirstDayOfMonth = (year: number, month: number) => new Date(year, month, 1).getDay();

  // Ethiopian leap year check
  const isEthLeapYear = (year: number) => {
    return (year % 4) === 3;
  };

  const getEthDaysInMonth = (month: number, year: number) => {
    if (month === 13) return isEthLeapYear(year) ? 6 : 5;
    return 30;
  };

  const getEthFirstDayOfMonth = (year: number, month: number) => {
    try {
      const gDate = new EthDateTime(year, month, 1).toEuropeanDate();
      return gDate.getDay();
    } catch (e) {
      return 0;
    }
  };

  const handlePrevMonth = () => {
    if (calendarType === "ethiopian") {
      if (ethMonth === 1) {
        setEthMonth(13);
        setEthYear(ethYear - 1);
      } else {
        setEthMonth(ethMonth - 1);
      }
    } else {
      setViewDate(new Date(viewDate.getFullYear(), viewDate.getMonth() - 1, 1));
    }
  };

  const handleNextMonth = () => {
    if (calendarType === "ethiopian") {
      if (ethMonth === 13) {
        setEthMonth(1);
        setEthYear(ethYear + 1);
      } else {
        setEthMonth(ethMonth + 1);
      }
    } else {
      setViewDate(new Date(viewDate.getFullYear(), viewDate.getMonth() + 1, 1));
    }
  };

  const handleSelectDate = (day: number) => {
    if (calendarType === "ethiopian") {
      try {
        const gDate = new EthDateTime(ethYear, ethMonth, day).toEuropeanDate();
        onChange(gDate);
      } catch (e) {
        console.error("Invalid Ethiopian date", e);
      }
    } else {
      onChange(new Date(viewDate.getFullYear(), viewDate.getMonth(), day));
    }
    setIsOpen(false);
  };

  const renderCalendar = () => {
    const isEth = calendarType === "ethiopian";
    
    let days = [];
    let firstDay = 0;
    let daysInMonth = 0;
    let monthLabel = "";
    let yearLabel = "";

    const isAmharic = language === "am";
    const weekdays = isAmharic ? WEEKDAYS_AM : WEEKDAYS_EN;

    if (isEth) {
      firstDay = getEthFirstDayOfMonth(ethYear, ethMonth);
      daysInMonth = getEthDaysInMonth(ethMonth, ethYear);
      monthLabel = isAmharic ? AM_MONTHS_ETH[ethMonth - 1] : EN_MONTHS_ETH[ethMonth - 1];
      yearLabel = ethYear.toString();
    } else {
      firstDay = getFirstDayOfMonth(viewDate.getFullYear(), viewDate.getMonth());
      daysInMonth = getDaysInMonth(viewDate.getFullYear(), viewDate.getMonth());
      monthLabel = isAmharic ? GREG_MONTHS_AM[viewDate.getMonth()] : GREG_MONTHS_EN[viewDate.getMonth()];
      yearLabel = viewDate.getFullYear().toString();
    }

    // Previous month blanks
    for (let i = 0; i < firstDay; i++) {
      days.push(<div key={`blank-${i}`} className="h-8 w-8"></div>);
    }

    // Days
    for (let d = 1; d <= daysInMonth; d++) {
      let isSelected = false;
      let isToday = false;

      if (value) {
        if (isEth) {
          try {
            const vEth = EthDateTime.fromEuropeanDate(value);
            isSelected = vEth.year === ethYear && vEth.month === ethMonth && vEth.date === d;
          } catch (e) {}
        } else {
          isSelected = value.getDate() === d && value.getMonth() === viewDate.getMonth() && value.getFullYear() === viewDate.getFullYear();
        }
      }

      const today = new Date();
      if (isEth) {
        try {
          const tEth = EthDateTime.fromEuropeanDate(today);
          isToday = tEth.year === ethYear && tEth.month === ethMonth && tEth.date === d;
        } catch(e) {}
      } else {
        isToday = today.getDate() === d && today.getMonth() === viewDate.getMonth() && today.getFullYear() === viewDate.getFullYear();
      }

      days.push(
        <button
          key={`day-${d}`}
          onClick={() => handleSelectDate(d)}
          className={`h-8 w-8 rounded-full flex items-center justify-center text-sm transition-all
            ${isSelected 
              ? "bg-[#4B9BDC] text-white font-bold shadow-md" 
              : isToday 
                ? "bg-blue-50 dark:bg-blue-900/30 text-[#4B9BDC] font-bold" 
                : "text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800"
            }
          `}
        >
          {d}
        </button>
      );
    }

    return (
      <div className="p-4 w-72 bg-white dark:bg-gray-900 rounded-2xl shadow-xl border border-gray-100 dark:border-gray-800">
        {/* Header */}
        <div className="flex items-center justify-between mb-4">
          <button onClick={handlePrevMonth} className="p-1.5 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 transition-colors">
            <ChevronLeft size={18} />
          </button>
          <div className="font-bold text-gray-900 dark:text-white">
            {monthLabel} {yearLabel}
          </div>
          <button onClick={handleNextMonth} className="p-1.5 rounded-xl hover:bg-gray-100 dark:hover:bg-gray-800 text-gray-500 transition-colors">
            <ChevronRight size={18} />
          </button>
        </div>

        {/* Weekdays */}
        <div className="grid grid-cols-7 gap-1 mb-2">
          {weekdays.map(w => (
            <div key={w} className="h-8 flex items-center justify-center text-xs font-bold text-gray-400">
              {w}
            </div>
          ))}
        </div>

        {/* Days Grid */}
        <div className="grid grid-cols-7 gap-1">
          {days}
        </div>
      </div>
    );
  };

  return (
    <div className={`relative ${className}`} ref={containerRef}>
      <div className="flex items-center gap-2">
        <button
          onClick={() => setIsOpen(!isOpen)}
          className="flex-1 flex items-center gap-2 px-4 py-3 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-2xl shadow-sm text-sm font-medium text-gray-700 dark:text-gray-200 hover:border-[#4B9BDC] focus:outline-none focus:ring-2 focus:ring-[#4B9BDC]/20 transition-all text-left"
        >
          <CalendarIcon size={18} className="text-[#4B9BDC]" />
          <span className="flex-1 truncate">
            {value ? formatDisplayDate(value, calendarType, language) : placeholder}
          </span>
        </button>
        
        {value && (
          <button
            onClick={(e) => {
              e.stopPropagation();
              onChange(null);
            }}
            className="p-3 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-2xl shadow-sm hover:bg-gray-50 dark:hover:bg-gray-800 text-gray-400 hover:text-red-500 transition-colors"
            title={t("common.clear") || "Clear"}
          >
            <X size={18} />
          </button>
        )}
      </div>

      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 10, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 10, scale: 0.95 }}
            transition={{ duration: 0.15 }}
            className="absolute z-50 mt-2 right-0 md:left-0 origin-top-right md:origin-top-left"
          >
            {renderCalendar()}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
