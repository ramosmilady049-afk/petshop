# Pet Shop Backend

1. Configura `backend/.env` con tus credenciales MySQL (copia de `.env.example`).
2. Crea la BD: ejecuta `backend/schema.sql` en MySQL.
3. Instala deps: `cd backend && npm install`
4. Ejecuta: `npm run dev` (http://localhost:3000)
5. Health check: `GET /api/health`

Flutter usa `lib/services/api_service.dart` con `baseUrl` (por defecto localhost:3000). Para APK en dispositivo físico, ejecuta con `--dart-define=API_BASE_URL=http://IP_DE_TU_PC:3000`. La app web y la app móvil comparten la misma BD MySQL a través de este backend.
