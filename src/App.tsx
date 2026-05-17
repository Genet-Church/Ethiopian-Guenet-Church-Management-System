import React from "react";
import {
  createHashRouter,
  RouterProvider,
  createRoutesFromElements,
  Route,
  Navigate,
} from "react-router-dom";
import { Toaster } from "react-hot-toast";
import { AuthProvider, useAuth } from "./context/AuthContext";
import { ThemeProvider } from "./context/ThemeContext";
import { LanguageProvider } from "./context/LanguageContext";
import Login from "./pages/Login";
import UpdatePassword from "./pages/UpdatePassword";
import Maintenance from "./pages/Maintenance";
import ErrorBoundary from "./components/ErrorBoundary";
import Layout from "./components/Layout";
import DashboardHome from "./pages/DashboardHome";
import Churches from "./pages/Churches";
import Departments from "./pages/Departments";
import Members from "./pages/Members";
import Settings from "./pages/Settings";
import Admins from "./pages/Admins";
import Servants from "./pages/Servants";
import Activities from "./pages/Activities";
import AddMember from "./pages/AddMember";
import Reports from "./pages/Reports";

const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const { session, profile, loading, settings } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-950 text-guenet-green">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-guenet-gold"></div>
      </div>
    );
  }

  if (!session || !profile) {
    return <Navigate to="/login" />;
  }

  if (settings?.is_maintenance_mode && profile.role !== "super_admin") {
    return <Navigate to="/maintenance" />;
  }

  return <>{children}</>;
};

const RoleGuard = ({
  allowedRoles,
  children,
}: {
  allowedRoles: string[];
  children: React.ReactNode;
}) => {
  const { profile, loading } = useAuth();

  if (loading) {
    return (
      <div className="flex items-center justify-center h-full">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-guenet-green"></div>
      </div>
    );
  }

  if (!profile || !allowedRoles.includes(profile.role)) {
    return <Navigate to="/" replace />;
  }

  return <>{children}</>;
};

const router = createHashRouter(
  createRoutesFromElements(
    <>
      <Route path="/login" element={<Login />} />
      <Route path="/update-password" element={<UpdatePassword />} />
      <Route path="/maintenance" element={<Maintenance />} />

      <Route
        path="/"
        element={
          <ProtectedRoute>
            <Layout />
          </ProtectedRoute>
        }
      >
        <Route index element={<DashboardHome />} />

        <Route
          path="churches"
          element={
            <RoleGuard allowedRoles={["super_admin"]}>
              <Churches />
            </RoleGuard>
          }
        />

        <Route
          path="admins"
          element={
            <RoleGuard allowedRoles={["super_admin"]}>
              <Admins />
            </RoleGuard>
          }
        />
        <Route
          path="servants"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin"]}>
              <Servants />
            </RoleGuard>
          }
        />
        <Route
          path="departments"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin", "servant"]}>
              <Departments />
            </RoleGuard>
          }
        />
        <Route
          path="departments/:id"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin", "servant"]}>
              <Departments />
            </RoleGuard>
          }
        />

        <Route
          path="members"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin", "servant"]}>
              <Members />
            </RoleGuard>
          }
        />
        <Route
          path="members/:id"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin", "servant"]}>
              <Members />
            </RoleGuard>
          }
        />

        <Route
          path="members/add"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin", "servant"]}>
              <AddMember />
            </RoleGuard>
          }
        />
        <Route
          path="members/edit/:id"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin", "servant"]}>
              <AddMember />
            </RoleGuard>
          }
        />

        <Route
          path="settings"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin", "servant"]}>
              <Settings />
            </RoleGuard>
          }
        />
        <Route
          path="activities"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin", "servant"]}>
              <Activities />
            </RoleGuard>
          }
        />

        <Route
          path="reports"
          element={
            <RoleGuard allowedRoles={["super_admin", "admin"]}>
              <Reports />
            </RoleGuard>
          }
        />

        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </>
  )
);

export default function App() {
  return (
    <ThemeProvider>
      <AuthProvider>
        <LanguageProvider>
          <ErrorBoundary>
            <Toaster
              position="top-right"
              toastOptions={{
                className: "text-sm font-medium rounded-xl shadow-lg border dark:border-gray-800",
                duration: 4000,
                style: {
                  background: 'var(--toast-bg, #fff)',
                  color: 'var(--toast-color, #374151)',
                },
                success: {
                  iconTheme: {
                    primary: "#4B9BDC",
                    secondary: "#fff",
                  },
                },
              }}
            />
            <RouterProvider router={router} />
          </ErrorBoundary>
        </LanguageProvider>
      </AuthProvider>
    </ThemeProvider>
  );
}
