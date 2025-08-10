# 🚀 How to Start and Test Admin Delete Functionality

## Quick Start Options

### Option 1: Using Batch File (Recommended)
```cmd
start-app.bat
```

### Option 2: Using PowerShell
```powershell
.\start-app.ps1
```

### Option 3: Direct Maven Command
```cmd
mvn spring-boot:run
```

### Option 4: Using Maven Wrapper (if Maven not installed)
```cmd
.\mvnw.cmd spring-boot:run
```

## Testing Instructions

### 1. Start the Application
- Run one of the commands above
- Wait for "Started SpairpartsApplication" message
- Application will be available at: `http://localhost:8082`

### 2. Test Admin User (Should See Delete Buttons)
1. Open browser: `http://localhost:8082/login`
2. Login with:
   - **Username:** `admin`
   - **Password:** `admin123`
3. Go to dashboard: `http://localhost:8082/dashboard`
4. **Expected:** You should see red "🗑️ Delete" buttons on each item card
5. Click a delete button to test - should show confirmation dialog
6. Confirm deletion - item should be removed

### 3. Test Regular User (Should NOT See Delete Buttons)
1. Logout from admin account
2. Login with:
   - **Username:** `user`
   - **Password:** `user123`
3. Go to dashboard
4. **Expected:** NO delete buttons should be visible anywhere
5. Interface should be clean without any admin features

## What You Should See

### Admin Dashboard:
```
[Item Card]
┌─────────────────────────────┐
│ Item Name               ID:1│
│ Description...              │
│ Price: $100    [🗑️ Delete] │
└─────────────────────────────┘
```

### User Dashboard:
```
[Item Card]
┌─────────────────────────────┐
│ Item Name               ID:1│
│ Description...              │
│ Price: $100                 │
└─────────────────────────────┘
```

## Troubleshooting

### If Application Won't Start:
1. Check if port 8082 is free: `netstat -an | findstr 8082`
2. Ensure MySQL is running (if using MySQL profile)
3. Try using H2 profile: `mvn spring-boot:run -Dspring.profiles.active=test`

### If Delete Buttons Don't Appear for Admin:
1. Clear browser cache
2. Check browser console (F12) for JavaScript errors
3. Verify you're logged in as "admin" user
4. Refresh the page

## Expected Behavior Summary

✅ **Admin user (`admin`/`admin123`):**
- Sees "ADMIN" badge in welcome message
- Has red delete buttons on all item cards
- Can successfully delete items
- Gets confirmation dialogs

❌ **Regular user (`user`/`user123`):**
- No "ADMIN" badge visible
- No delete buttons anywhere
- Clean, read-only interface
- Cannot access delete functionality

🔒 **Security verified at multiple levels:**
- Frontend: Buttons only rendered for admins
- JavaScript: Function validates admin status
- Backend: API enforces role-based access control

**The delete functionality is properly restricted to admin users only!**
