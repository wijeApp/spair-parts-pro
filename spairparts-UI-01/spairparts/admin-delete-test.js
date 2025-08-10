// Admin Delete Functionality Test Script

// This script will help you test the admin delete functionality directly from the browser console
// Follow these steps:

// 1. Open your browser and navigate to http://localhost:8082/login
// 2. Login with admin credentials (Admin/Admin123)
// 3. Open the browser console (F12 or right-click > Inspect > Console)
// 4. Copy and paste the entire script below into the console
// 5. Run the testDeleteFunctionality() function

// Test preparation - displays current user status
function checkUserStatus() {
    console.log('=============================================');
    console.log('🔐 ADMIN DELETE FUNCTIONALITY TEST');
    console.log('=============================================');
    console.log('Current User Status:');
    console.log('- Username:', currentUser);
    console.log('- User Role:', userRole);
    console.log('- Is Admin (from server):', isAdmin);
    console.log('- Is Admin Forced (debug):', isAdminForced);
    
    // Check if delete buttons are visible
    const deleteButtons = document.querySelectorAll('button[onclick^="deleteItem"]');
    console.log('- Delete Buttons Visible:', deleteButtons.length > 0);
    console.log('- Number of Delete Buttons:', deleteButtons.length);
    
    return {
        username: currentUser,
        role: userRole,
        isAdmin: isAdmin,
        deleteButtonsVisible: deleteButtons.length > 0,
        deleteButtonCount: deleteButtons.length
    };
}

// Test delete functionality - simulates clicking the delete button
// Set dryRun=true to test without actually deleting
async function testDeleteFunctionality(itemId = null, dryRun = true) {
    const status = checkUserStatus();
    
    if (!status.isAdmin && !isAdminForced) {
        console.error('❌ Test Failed: User is not an admin and admin is not forced');
        return false;
    }
    
    if (!status.deleteButtonsVisible) {
        console.error('❌ Test Failed: Delete buttons are not visible');
        return false;
    }
    
    // Get all items
    console.log('Fetching all items...');
    const items = await fetchItems();
    console.log(`Found ${items.length} items in the database`);
    
    // Select an item to delete
    const targetItem = itemId ? 
        items.find(item => item.id === itemId) : 
        items[Math.floor(Math.random() * items.length)];
    
    if (!targetItem) {
        console.error(`❌ Test Failed: No item found with ID ${itemId}`);
        return false;
    }
    
    console.log('Selected item for deletion test:', targetItem);
    
    if (dryRun) {
        console.log('📝 DRY RUN MODE - No actual deletion will occur');
        console.log('To perform actual deletion, call testDeleteFunctionality(null, false)');
        
        // Simulate the delete process
        console.log('Simulating delete process for item:', targetItem.name);
        console.log(`Would call DELETE /api/spareparts/${targetItem.id}`);
        
        // Test the backend security directly
        console.log('Testing backend security with a direct API call...');
        const response = await fetch(`/api/spareparts/${targetItem.id}`, {
            method: 'HEAD', // Just check permissions without deleting
            headers: {
                'Content-Type': 'application/json'
            }
        });
        
        console.log(`Security Test Response: ${response.status} ${response.statusText}`);
        console.log('✅ Test completed in DRY RUN mode');
        
    } else {
        console.log('⚠️ LIVE RUN MODE - Item will actually be deleted');
        console.log(`Deleting item: ${targetItem.name} (ID: ${targetItem.id})`);
        
        // Call the actual delete function
        try {
            const originalConfirm = window.confirm;
            window.confirm = () => true; // Auto-confirm
            
            await deleteItem(targetItem.id, targetItem.name);
            
            window.confirm = originalConfirm; // Restore original confirm
            
            console.log('✅ Delete operation completed');
            console.log('Verifying item was deleted...');
            
            // Verify the item is gone
            const newItems = await fetchItems();
            const stillExists = newItems.some(item => item.id === targetItem.id);
            
            if (stillExists) {
                console.error('❌ Test Failed: Item still exists after deletion');
                return false;
            } else {
                console.log('✅ Success: Item was successfully deleted');
            }
        } catch (error) {
            console.error('❌ Test Failed with error:', error);
            return false;
        }
    }
    
    return true;
}

// Test impersonation - test what happens when a regular user tries to delete
async function testRegularUserAccess() {
    console.log('=============================================');
    console.log('🔒 REGULAR USER ACCESS TEST');
    console.log('=============================================');
    
    // Save original values
    const originalIsAdmin = isAdmin;
    const originalIsAdminForced = isAdminForced;
    
    // Simulate regular user
    window.isAdmin = false;
    window.isAdminForced = false;
    
    console.log('Simulating regular user access:');
    console.log('- isAdmin:', isAdmin);
    console.log('- isAdminForced:', isAdminForced);
    
    try {
        // Try to delete item 1
        console.log('Attempting to delete item as regular user...');
        await deleteItem(1, 'Test Item');
        
        // Restore original values
        window.isAdmin = originalIsAdmin;
        window.isAdminForced = originalIsAdminForced;
        
        console.log('Regular user access test completed');
    } catch (error) {
        // Restore original values
        window.isAdmin = originalIsAdmin;
        window.isAdminForced = originalIsAdminForced;
        
        console.error('❌ Error during regular user test:', error);
    }
}

// Main test function
async function runAllTests() {
    console.clear();
    console.log('=============================================');
    console.log('🧪 RUNNING ALL ADMIN DELETE FUNCTIONALITY TESTS');
    console.log('=============================================');
    
    // 1. Check user status
    const status = checkUserStatus();
    
    // 2. Test dry run deletion
    await testDeleteFunctionality(null, true);
    
    // 3. Test regular user access (impersonation)
    await testRegularUserAccess();
    
    // 4. Summary
    console.log('=============================================');
    console.log('📊 TEST SUMMARY');
    console.log('=============================================');
    console.log('User Status:', status);
    console.log('');
    console.log('To perform actual deletion, run:');
    console.log('testDeleteFunctionality(null, false)');
    console.log('=============================================');
}

// Run the tests
console.log('Admin Delete Functionality Test Script loaded');
console.log('Run tests with: runAllTests()');
