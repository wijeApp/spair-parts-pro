// Admin Update Functionality Test Script

// This script will help you test the admin update functionality directly from the browser console
// Follow these steps:

// 1. Open your browser and navigate to http://localhost:8082/login
// 2. Login with admin credentials (Admin/Admin123)
// 3. Open the browser console (F12 or right-click > Inspect > Console)
// 4. Copy and paste the entire script below into the console
// 5. Run the testUpdateFunctionality() function

// Test preparation - displays current user status and update button availability
function checkUpdateFunctionality() {
    console.log('=============================================');
    console.log('✏️ ADMIN UPDATE FUNCTIONALITY TEST');
    console.log('=============================================');
    console.log('Current User Status:');
    console.log('- Username:', currentUser);
    console.log('- User Role:', userRole);
    console.log('- Is Admin (from server):', isAdmin);
    
    // Check if update buttons are visible
    const updateButtons = document.querySelectorAll('button[onclick^="openUpdateModal"]');
    console.log('- Update Buttons Visible:', updateButtons.length > 0);
    console.log('- Number of Update Buttons:', updateButtons.length);
    
    // Check if delete buttons are visible (for comparison)
    const deleteButtons = document.querySelectorAll('button[onclick^="deleteItem"]');
    console.log('- Delete Buttons Visible:', deleteButtons.length > 0);
    console.log('- Number of Delete Buttons:', deleteButtons.length);
    
    // Check if update modal exists
    const updateModal = document.getElementById('updateModal');
    console.log('- Update Modal Available:', updateModal !== null);
    
    return {
        username: currentUser,
        role: userRole,
        isAdmin: isAdmin,
        updateButtonsVisible: updateButtons.length > 0,
        updateButtonCount: updateButtons.length,
        deleteButtonCount: deleteButtons.length,
        modalAvailable: updateModal !== null
    };
}

// Test update modal functionality
async function testUpdateModal(itemId = null) {
    const status = checkUpdateFunctionality();
    
    if (!status.isAdmin) {
        console.error('❌ Test Failed: User is not an admin');
        return false;
    }
    
    if (!status.updateButtonsVisible) {
        console.error('❌ Test Failed: Update buttons are not visible');
        return false;
    }
    
    if (!status.modalAvailable) {
        console.error('❌ Test Failed: Update modal is not available');
        return false;
    }
    
    // Get all items
    console.log('Fetching all items...');
    const items = await fetchItems();
    console.log(`Found ${items.length} items in the database`);
    
    // Select an item to update
    const targetItem = itemId ? 
        items.find(item => item.id === itemId) : 
        items[Math.floor(Math.random() * items.length)];
    
    if (!targetItem) {
        console.error(`❌ Test Failed: No item found with ID ${itemId}`);
        return false;
    }
    
    console.log('Selected item for update test:', targetItem);
    
    // Test opening the modal
    console.log('Testing modal opening...');
    openUpdateModal(
        targetItem.id, 
        targetItem.name, 
        targetItem.description, 
        targetItem.price, 
        targetItem.quantity, 
        targetItem.currency || 'LKR'
    );
    
    // Check if modal is visible
    const modal = document.getElementById('updateModal');
    const isModalVisible = !modal.classList.contains('hidden');
    console.log('Modal opened successfully:', isModalVisible);
    
    if (!isModalVisible) {
        console.error('❌ Test Failed: Modal did not open');
        return false;
    }
    
    // Check if form is populated correctly
    const populatedCorrectly = 
        document.getElementById('update-item-id').value == targetItem.id &&
        document.getElementById('update-item-name').value === targetItem.name &&
        document.getElementById('update-item-description').value === targetItem.description &&
        parseFloat(document.getElementById('update-item-price').value) === targetItem.price &&
        parseInt(document.getElementById('update-item-quantity').value) === targetItem.quantity &&
        document.getElementById('update-item-currency').value === (targetItem.currency || 'LKR');
    
    console.log('Form populated correctly:', populatedCorrectly);
    
    if (!populatedCorrectly) {
        console.warn('⚠️ Warning: Form may not be populated correctly');
        console.log('Expected vs Actual values:');
        console.log('ID:', targetItem.id, 'vs', document.getElementById('update-item-id').value);
        console.log('Name:', targetItem.name, 'vs', document.getElementById('update-item-name').value);
        console.log('Description:', targetItem.description, 'vs', document.getElementById('update-item-description').value);
        console.log('Price:', targetItem.price, 'vs', parseFloat(document.getElementById('update-item-price').value));
        console.log('Quantity:', targetItem.quantity, 'vs', parseInt(document.getElementById('update-item-quantity').value));
        console.log('Currency:', (targetItem.currency || 'LKR'), 'vs', document.getElementById('update-item-currency').value);
    }
    
    // Test closing the modal
    console.log('Testing modal closing...');
    closeUpdateModal();
    
    const isModalClosed = modal.classList.contains('hidden');
    console.log('Modal closed successfully:', isModalClosed);
    
    return isModalVisible && isModalClosed;
}

// Test actual update functionality with dry run option
async function testUpdateFunctionality(itemId = null, dryRun = true, modifyFields = {}) {
    const status = checkUpdateFunctionality();
    
    if (!status.isAdmin) {
        console.error('❌ Test Failed: User is not an admin');
        return false;
    }
    
    // Get all items
    console.log('Fetching all items...');
    const items = await fetchItems();
    console.log(`Found ${items.length} items in the database`);
    
    // Select an item to update
    const targetItem = itemId ? 
        items.find(item => item.id === itemId) : 
        items[Math.floor(Math.random() * items.length)];
    
    if (!targetItem) {
        console.error(`❌ Test Failed: No item found with ID ${itemId}`);
        return false;
    }
    
    console.log('Selected item for update test:', targetItem);
    
    // Prepare update data with modifications
    const updatedData = {
        name: modifyFields.name || targetItem.name + ' (Updated)',
        description: modifyFields.description || targetItem.description + ' - Modified for testing',
        price: modifyFields.price !== undefined ? modifyFields.price : targetItem.price + 100,
        quantity: modifyFields.quantity !== undefined ? modifyFields.quantity : targetItem.quantity + 5,
        currency: modifyFields.currency || targetItem.currency || 'LKR'
    };
    
    console.log('Proposed update data:', updatedData);
    
    if (dryRun) {
        console.log('📝 DRY RUN MODE - No actual update will occur');
        console.log('To perform actual update, call testUpdateFunctionality(null, false)');
        
        // Simulate the update process
        console.log('Simulating update process...');
        console.log(`Would call PUT /api/spareparts/${targetItem.id}`);
        console.log('Request body:', JSON.stringify(updatedData, null, 2));
        
        // Test the backend security directly with HEAD request
        console.log('Testing backend security with a direct API call...');
        const response = await fetch(`/api/spareparts/${targetItem.id}`, {
            method: 'HEAD',
            headers: {
                'Content-Type': 'application/json'
            }
        });
        
        console.log(`Security Test Response: ${response.status} ${response.statusText}`);
        console.log('✅ Test completed in DRY RUN mode');
        
    } else {
        console.log('⚠️ LIVE RUN MODE - Item will actually be updated');
        console.log(`Updating item: ${targetItem.name} (ID: ${targetItem.id})`);
        
        // Call the actual update function
        try {
            await updateItem(targetItem.id, updatedData);
            
            console.log('✅ Update operation completed');
            console.log('Verifying item was updated...');
            
            // Wait a moment for the dashboard to refresh
            await new Promise(resolve => setTimeout(resolve, 2000));
            
            // Verify the item was updated
            const newItems = await fetchItems();
            const updatedItem = newItems.find(item => item.id === targetItem.id);
            
            if (!updatedItem) {
                console.error('❌ Test Failed: Item not found after update');
                return false;
            }
            
            const wasUpdated = 
                updatedItem.name === updatedData.name &&
                updatedItem.description === updatedData.description &&
                Math.abs(updatedItem.price - updatedData.price) < 0.01 &&
                updatedItem.quantity === updatedData.quantity &&
                updatedItem.currency === updatedData.currency;
            
            if (wasUpdated) {
                console.log('✅ Success: Item was successfully updated');
                console.log('Updated item:', updatedItem);
            } else {
                console.error('❌ Test Failed: Item was not updated correctly');
                console.log('Expected:', updatedData);
                console.log('Actual:', updatedItem);
                return false;
            }
        } catch (error) {
            console.error('❌ Test Failed with error:', error);
            return false;
        }
    }
    
    return true;
}

// Test regular user access (impersonation)
async function testRegularUserUpdateAccess() {
    console.log('=============================================');
    console.log('🔒 REGULAR USER UPDATE ACCESS TEST');
    console.log('=============================================');
    
    // Save original values
    const originalIsAdmin = isAdmin;
    
    // Simulate regular user
    window.isAdmin = false;
    
    console.log('Simulating regular user access:');
    console.log('- isAdmin:', isAdmin);
    
    try {
        // Try to open update modal
        console.log('Attempting to open update modal as regular user...');
        openUpdateModal(1, 'Test Item', 'Test Description', 100, 10, 'LKR');
        
        // Try to update item directly
        console.log('Attempting to update item as regular user...');
        await updateItem(1, {
            name: 'Test Update',
            description: 'Test Description',
            price: 200,
            quantity: 20,
            currency: 'LKR'
        });
        
        // Restore original values
        window.isAdmin = originalIsAdmin;
        
        console.log('Regular user update access test completed');
    } catch (error) {
        // Restore original values
        window.isAdmin = originalIsAdmin;
        
        console.error('❌ Error during regular user test:', error);
    }
}

// Main test function
async function runAllUpdateTests() {
    console.clear();
    console.log('=============================================');
    console.log('🧪 RUNNING ALL ADMIN UPDATE FUNCTIONALITY TESTS');
    console.log('=============================================');
    
    // 1. Check update functionality status
    const status = checkUpdateFunctionality();
    
    // 2. Test modal functionality
    await testUpdateModal();
    
    // 3. Test dry run update
    await testUpdateFunctionality(null, true);
    
    // 4. Test regular user access (impersonation)
    await testRegularUserUpdateAccess();
    
    // 5. Summary
    console.log('=============================================');
    console.log('📊 UPDATE FUNCTIONALITY TEST SUMMARY');
    console.log('=============================================');
    console.log('Status:', status);
    console.log('');
    console.log('To perform actual update, run:');
    console.log('testUpdateFunctionality(null, false)');
    console.log('');
    console.log('To test specific item update:');
    console.log('testUpdateFunctionality(ITEM_ID, false, {name: "New Name", price: 999})');
    console.log('=============================================');
}

// Quick test for a specific item
async function quickUpdateTest(itemId, newName, newPrice) {
    return await testUpdateFunctionality(itemId, false, {
        name: newName,
        price: newPrice
    });
}

// Run the tests
console.log('Admin Update Functionality Test Script loaded');
console.log('Available functions:');
console.log('- runAllUpdateTests() - Run complete test suite');
console.log('- testUpdateModal() - Test modal functionality only');
console.log('- testUpdateFunctionality(itemId, dryRun, modifications) - Test update process');
console.log('- quickUpdateTest(itemId, newName, newPrice) - Quick update test');
console.log('');
console.log('Start with: runAllUpdateTests()');
