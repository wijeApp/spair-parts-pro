// Statistics Fix Verification Test
// Run this in the browser console after logging into the dashboard

console.log("=== STATISTICS FIX VERIFICATION ===");

// Test 1: Check if statistics elements exist
function testStatisticsElements() {
    console.log("1. Testing Statistics Elements...");
    
    const totalItems = document.getElementById('total-items');
    const totalValue = document.getElementById('total-value');
    const lowStock = document.getElementById('low-stock');
    const avgPrice = document.getElementById('avg-price');
    
    console.log("   Total Items element:", totalItems ? "✅ Found" : "❌ Missing");
    console.log("   Total Value element:", totalValue ? "✅ Found" : "❌ Missing");
    console.log("   Low Stock element:", lowStock ? "✅ Found" : "❌ Missing");
    console.log("   Average Price element:", avgPrice ? "✅ Found" : "❌ Missing");
    
    return { totalItems, totalValue, lowStock, avgPrice };
}

// Test 2: Check current statistics values
function testCurrentValues() {
    console.log("2. Testing Current Statistics Values...");
    
    const totalItems = document.getElementById('total-items')?.textContent || "N/A";
    const totalValue = document.getElementById('total-value')?.textContent || "N/A";
    const lowStock = document.getElementById('low-stock')?.textContent || "N/A";
    const avgPrice = document.getElementById('avg-price')?.textContent || "N/A";
    
    console.log("   Total Items:", totalItems);
    console.log("   Total Value:", totalValue);
    console.log("   Low Stock Items:", lowStock);
    console.log("   Average Price:", avgPrice);
    
    // Check if values are not zero (indicating the fix worked)
    const isFixed = totalItems !== "0" && totalItems !== "N/A";
    console.log("   Statistics Fix Status:", isFixed ? "✅ WORKING" : "❌ STILL SHOWING ZERO");
    
    return { totalItems, totalValue, lowStock, avgPrice, isFixed };
}

// Test 3: Check if JavaScript functions exist
function testJavaScriptFunctions() {
    console.log("3. Testing JavaScript Functions...");
    
    const functions = {
        fetchItems: typeof fetchItems !== 'undefined',
        updateStats: typeof updateStats !== 'undefined',
        loadDashboard: typeof loadDashboard !== 'undefined',
        calculateInitialStats: typeof calculateInitialStats !== 'undefined'
    };
    
    console.log("   fetchItems():", functions.fetchItems ? "✅ Found" : "❌ Missing");
    console.log("   updateStats():", functions.updateStats ? "✅ Found" : "❌ Missing");
    console.log("   loadDashboard():", functions.loadDashboard ? "✅ Found" : "❌ Missing");
    console.log("   calculateInitialStats():", functions.calculateInitialStats ? "✅ Found" : "❌ Missing");
    
    return functions;
}

// Test 4: Test API connectivity
async function testAPIConnectivity() {
    console.log("4. Testing API Connectivity...");
    
    try {
        const response = await fetch('/api/spareparts');
        console.log("   API Response Status:", response.status);
        
        if (response.ok) {
            const data = await response.json();
            console.log("   API Data Retrieved:", data.length, "items");
            console.log("   Sample Item:", data[0] || "No items");
            return { success: true, data };
        } else {
            console.log("   API Error:", response.statusText);
            return { success: false, error: response.statusText };
        }
    } catch (error) {
        console.log("   API Connection Failed:", error.message);
        return { success: false, error: error.message };
    }
}

// Test 5: Manual statistics update test
async function testManualStatisticsUpdate() {
    console.log("5. Testing Manual Statistics Update...");
    
    if (typeof fetchItems !== 'undefined' && typeof updateStats !== 'undefined') {
        try {
            console.log("   Fetching items manually...");
            const items = await fetchItems();
            console.log("   Items fetched:", items.length);
            
            console.log("   Updating statistics manually...");
            updateStats(items);
            console.log("   Statistics updated successfully");
            
            return { success: true, itemCount: items.length };
        } catch (error) {
            console.log("   Manual update failed:", error.message);
            return { success: false, error: error.message };
        }
    } else {
        console.log("   Required functions not available");
        return { success: false, error: "Functions not found" };
    }
}

// Run all tests
async function runAllTests() {
    console.log("=== RUNNING ALL STATISTICS TESTS ===");
    
    const elements = testStatisticsElements();
    const values = testCurrentValues();
    const functions = testJavaScriptFunctions();
    const api = await testAPIConnectivity();
    const manual = await testManualStatisticsUpdate();
    
    console.log("=== TEST RESULTS SUMMARY ===");
    console.log("Elements Present:", Object.values(elements).every(el => el) ? "✅ PASS" : "❌ FAIL");
    console.log("Statistics Working:", values.isFixed ? "✅ PASS" : "❌ FAIL");
    console.log("Functions Present:", Object.values(functions).every(fn => fn) ? "✅ PASS" : "❌ FAIL");
    console.log("API Connectivity:", api.success ? "✅ PASS" : "❌ FAIL");
    console.log("Manual Update:", manual.success ? "✅ PASS" : "❌ FAIL");
    
    const overallSuccess = values.isFixed && api.success;
    console.log("=== OVERALL STATUS ===");
    console.log("Statistics Fix:", overallSuccess ? "✅ SUCCESS" : "❌ NEEDS ATTENTION");
    
    return {
        elements,
        values,
        functions,
        api,
        manual,
        overall: overallSuccess
    };
}

// Auto-run if in browser console
if (typeof window !== 'undefined') {
    console.log("Browser environment detected. Run 'runAllTests()' to test statistics fix.");
    console.log("Or run individual tests: testStatisticsElements(), testCurrentValues(), etc.");
}

// Export for use
if (typeof module !== 'undefined') {
    module.exports = { runAllTests, testStatisticsElements, testCurrentValues, testJavaScriptFunctions, testAPIConnectivity, testManualStatisticsUpdate };
}
