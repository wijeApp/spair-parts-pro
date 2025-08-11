# Database Name Change: spareparts_db → spareparts_prod

## Summary
Changed database name from `spareparts_db` back to `spareparts_prod` across all configuration files and documentation.

## Files Updated

### Configuration Files
✅ **application.properties**
- Changed: `jdbc:mysql://localhost:3306/spareparts_db` → `jdbc:mysql://localhost:3306/spareparts_prod`

✅ **application-dev.properties** 
- Already configured with `spareparts_prod`
- No changes needed

✅ **application-prod.properties**
- Changed: `jdbc:mysql://localhost:3306/spareparts_db` → `jdbc:mysql://localhost:3306/spareparts_prod`

✅ **application-test.properties**
- Uses H2 in-memory database for testing
- No changes needed

### Test Scripts Updated
✅ **test-statistics-calculation.ps1**
- Updated database URL check to expect `spareparts_prod`

✅ **start-with-debug.bat**
- Updated display message to show `spareparts_prod`

✅ **test-calculate-stats.bat**
- Updated title to reference `spareparts_prod`

✅ **diagnose-error.bat**
- Updated database name references to `spareparts_prod`
- Updated verification command to use correct credentials

## Current Database Configuration

| Profile | Host | Database | Port | Username | Password |
|---------|------|----------|------|----------|-----------|
| Default | localhost | spareparts_prod | 3306 | sa | myRoot@123 |
| Dev | localhost | spareparts_prod | 3306 | sa | myRoot@123 |
| Prod | localhost | spareparts_prod | 3306 | sa | myRoot@123 |
| Test | H2 Memory | testdb | N/A | sa | (empty) |

## Database Setup Required

If you don't have a `spareparts_prod` database, create it:

```sql
CREATE DATABASE IF NOT EXISTS spareparts_prod CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE spareparts_prod;
```

Or the application will create it automatically due to `createDatabaseIfNotExist=true` parameter.

## Testing the Change

1. **Start the application:**
   ```powershell
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

2. **Verify database connection:**
   - Check logs for successful connection to `spareparts_prod`
   - Open: http://localhost:8082/dashboard

3. **Manual database verification:**
   ```sql
   mysql -u sa -p
   SHOW DATABASES;
   USE spareparts_prod;
   SHOW TABLES;
   ```

## Notes

- The `createDatabaseIfNotExist=true` parameter ensures the database is created automatically
- All existing data in `spareparts_db` (if any) will remain untouched
- The application will now use `spareparts_prod` for all environments
- Test profile continues to use H2 for isolated testing

## Status: ✅ COMPLETE

All configuration files and scripts have been updated to use `spareparts_prod` database name consistently.
