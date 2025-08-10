# Admin Delete Functionality Test Guide

## Overview
This document provides step-by-step instructions to test the admin delete functionality for spare parts management.

## Test Accounts
The application automatically creates these test accounts:

### Admin Account
- **Username:** `admin`
- **Password:** `admin123`
- **Role:** `ADMIN`
- **Permissions:** Can view and delete spare parts

### Regular User Account
- **Username:** `user`
- **Password:** `user123`
- **Role:** `USER`
- **Permissions:** Can only view spare parts (no delete access)

## Starting the Application

### Option 1: Using Batch File
```bash
.\test-admin-delete.bat
```

### Option 2: Manual Start
```bash
mvn spring-boot:run
```

The application will start on: `http://localhost:8082`

## Test Scenarios

### Test 1: Admin User Delete Functionality

1. **Access Login Page**
   - Navigate to: `http://localhost:8082/login`
   - Should see login form

2. **Login as Admin**
   - Username: `admin`
   - Password: `admin123`
   - Click "Login"

3. **Verify Admin Status**
   - Should see "Welcome, admin! ADMIN" badge in header
   - Dashboard should load with spare parts items

4. **Check Delete Buttons**
   - ✅ **Expected:** Each item card should have a red "🗑️ Delete" button
   - ✅ **Expected:** Delete buttons should be visible and clickable

5. **Test Delete Functionality**
   - Click delete button on any item
   - ✅ **Expected:** Confirmation dialog appears: "🗑️ Are you sure you want to delete [item name]?"
   - Confirm deletion
   - ✅ **Expected:** Item is removed from the list
   - ✅ **Expected:** Success message appears

6. **Verify Database Update**
   - Refresh the page
   - ✅ **Expected:** Deleted item should not reappear

### Test 2: Regular User Restrictions

1. **Logout from Admin**
   - Click "🚪 Logout" button

2. **Login as Regular User**
   - Username: `user`
   - Password: `user123`
   - Click "Login"

3. **Verify User Status**
   - Should see "Welcome, user!" (no ADMIN badge)
   - Dashboard should load with spare parts items

4. **Check for Delete Buttons**
   - ✅ **Expected:** NO delete buttons should be visible on any item cards
   - ✅ **Expected:** Only item information should be displayed

5. **Verify API Security**
   - Open browser developer tools (F12)
   - Try manual DELETE request (if you know how):
     ```javascript
     fetch('/api/spareparts/1', { method: 'DELETE' })
     ```
   - ✅ **Expected:** Should return 403 Forbidden error

## Browser Console Debugging

Open browser developer tools (F12) and check the Console tab for debug information:

### Expected Console Output for Admin Users:
```
User Info: { username: "admin", role: "ADMIN", isAdmin: true }
Admin status check: true boolean
Rendering item: 1 isAdmin: true deleteButtonHtml: present
```

### Expected Console Output for Regular Users:
```
User Info: { username: "user", role: "USER", isAdmin: false }
Admin status check: false boolean
Rendering item: 1 isAdmin: false deleteButtonHtml: empty
```

## Troubleshooting

### Issue: Delete Buttons Not Appearing for Admin
1. Check browser console for JavaScript errors
2. Verify admin login credentials
3. Check that `isAdmin` variable is `true` in console
4. Refresh the page after login

### Issue: Application Won't Start
1. Ensure MySQL is running
2. Check database connection in `application.properties`
3. Verify port 8082 is not in use by another application

### Issue: Database Connection Errors
1. Ensure MySQL server is running
2. Verify database credentials in `application.properties`
3. Create database manually: `CREATE DATABASE spairparts_db;`

## Expected File Changes Made

### Backend Changes:
- `SparePartsController.java`: Added admin role validation for DELETE endpoint
- `SparePartsService.java`: Integrated with JPA repository for database operations
- `SparePartsViewController.java`: Added admin status passing to template

### Frontend Changes:
- `spareparts-sample.html`: 
  - Added conditional delete button rendering based on admin status
  - Implemented `deleteItem()` JavaScript function
  - Added admin badge in welcome message
  - Added proper error handling for delete operations

### Security Implementation:
- Backend validates user role before allowing deletion
- Frontend conditionally shows delete buttons based on user role
- Confirmation dialog prevents accidental deletions

## Success Criteria

✅ Admin users can see and use delete buttons  
✅ Regular users cannot see delete buttons  
✅ Delete operations remove items from database  
✅ Proper error handling for unauthorized access  
✅ User-friendly confirmation dialogs  
✅ Real-time UI updates after deletion  

## Next Steps

After successful testing:
1. Remove debug console logging from production code
2. Consider adding delete confirmation with item details
3. Add audit logging for delete operations
4. Implement soft delete (mark as deleted) instead of hard delete
