import React from "react";
import { Link, useLocation } from "react-router-dom";
import { ChevronRight, Home } from "lucide-react";
import { useLanguage } from "../context/LanguageContext";
import { motion } from "framer-motion";

export default function Breadcrumbs() {
  const location = useLocation();
  const { t } = useLanguage();

  const pathMap: Record<string, { label: string; icon?: React.ComponentType<any> }> = {
    "": { label: t("sidebar.dashboard"), icon: Home },
    "churches": { label: t("sidebar.churches") },
    "admins": { label: t("sidebar.admins") },
    "servants": { label: t("sidebar.servants") },
    "departments": { label: t("sidebar.departments") },
    "members": { label: t("sidebar.members") },
    "activities": { label: t("sidebar.activities") },
    "reports": { label: t("sidebar.reports") },
    "settings": { label: t("sidebar.settings") },
    "add": { label: t("members.addBtn") },
    "edit": { label: t("common.edit") },
  };

  const segments = location.pathname.split("/").filter(Boolean);

  // Don't show breadcrumbs on dashboard root
  if (segments.length === 0) return null;

  const crumbs = segments.map((segment, index) => {
    const path = "/" + segments.slice(0, index + 1).join("/");
    const isLast = index === segments.length - 1;
    const info = pathMap[segment];

    // Skip UUID-like segments in label but still build the path
    const isUuid = /^[0-9a-f]{8}-[0-9a-f]{4}/.test(segment);
    const label = info?.label || (isUuid ? "Details" : segment);

    return { path, label, isLast, isUuid };
  });

  return (
    <motion.nav
      initial={{ opacity: 0, y: -8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3, ease: "easeOut" }}
      className="flex items-center gap-1.5 text-sm mb-4 -mt-2 overflow-x-auto scrollbar-hide"
      aria-label="Breadcrumb"
    >
      <Link
        to="/"
        className="flex items-center gap-1 text-gray-400 dark:text-gray-500 hover:text-[#4B9BDC] dark:hover:text-[#7EC8F2] transition-colors shrink-0"
      >
        <Home size={14} />
      </Link>

      {crumbs.map((crumb, i) => (
        <React.Fragment key={crumb.path}>
          <ChevronRight size={12} className="text-gray-300 dark:text-gray-600 shrink-0" />
          {crumb.isLast ? (
            <span className="font-semibold text-gray-700 dark:text-gray-200 truncate max-w-[200px]">
              {crumb.label}
            </span>
          ) : (
            <Link
              to={crumb.path}
              className="text-gray-400 dark:text-gray-500 hover:text-[#4B9BDC] dark:hover:text-[#7EC8F2] transition-colors truncate max-w-[160px]"
            >
              {crumb.label}
            </Link>
          )}
        </React.Fragment>
      ))}
    </motion.nav>
  );
}
