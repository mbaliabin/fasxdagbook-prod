import { Routes, Route, Navigate } from "react-router-dom"
import { ProtectedRoute } from "./components/ProtectedRoute"

import HomePage from "@/pages/HomePage"
import ProfilePageWrapper from "@/pages/ProfilePageWrapper"
import CalendarPageWrapper from "@/pages/CalendarPageWrapper"
import DailyParametersWrapper from "@/pages/DailyParametersWrapper"
import StatisticsPageWrapper from "@/pages/StatisticsPageWrapper"
import AccountPageWrapper from "@/pages/AccountPageWrapper"

import FasxLogin from "@/pages/FasxLogin"
import FasxRegister from "@/pages/FasxRegister"
import PlanningStub from "@/pages/PlanningStub" // Наша новая заглушка

export default function App() {
  return (
    <Routes>
      {/* 1. ПУБЛИЧНЫЕ РОУТЫ */}
      <Route path="/login" element={<FasxLogin />} />
      <Route path="/register" element={<FasxRegister />} />
      
      {/* Редирект с корня */}
      <Route path="/" element={<Navigate to="/daily" replace />} />

      {/* 2. ЗАЩИЩЕННЫЕ РОУТЫ (Всегда внутри ProtectedRoute) */}
      <Route 
        path="/profile" 
        element={<ProtectedRoute><ProfilePageWrapper /></ProtectedRoute>} 
      />
      
      <Route 
        path="/calendar" 
        element={<ProtectedRoute><CalendarPageWrapper /></ProtectedRoute>} 
      />
      
      <Route 
        path="/daily" 
        element={<ProtectedRoute><DailyParametersWrapper /></ProtectedRoute>} 
      />
      
      <Route 
        path="/statistics" 
        element={<ProtectedRoute><StatisticsPageWrapper /></ProtectedRoute>} 
      />
      
      <Route 
        path="/account" 
        element={<ProtectedRoute><AccountPageWrapper /></ProtectedRoute>} 
      />

      {/* Роут для планирования (теперь выше звездочки) */}
      <Route 
        path="/planning" 
        element={<ProtectedRoute><PlanningStub /></ProtectedRoute>} 
      />

      {/* 3. ОБРАБОТКА НЕИЗВЕСТНЫХ ПУТЕЙ */}
      {/* Этот роут ДОЛЖЕН быть последним */}
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  )
}