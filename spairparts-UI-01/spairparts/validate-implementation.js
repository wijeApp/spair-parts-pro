#!/usr/bin/env node

// Quick validation script for admin delete functionality
console.log('🔍 Validating Admin Delete Implementation...\n');

const fs = require('fs');
const path = require('path');

// Check if required files exist and contain expected code
const checks = [
    {
        file: 'src/main/java/com/tas/spairparts/SparePartsController.java',
        patterns: [
            '@DeleteMapping("/{id}")',
            'Authentication authentication',
            '"ADMIN".equals(user.getRole())',
            'ResponseEntity.status(403)'
        ],
        description: 'Backend DELETE endpoint with admin validation'
    },
    {
        file: 'src/main/resources/templates/spareparts-sample.html',
        patterns: [
            'const isAdmin = /*[[${isAdmin ?: false}]]*/ false;',
            'deleteItem(itemId, itemName)',
            'isAdmin ?',
            '🗑️ Delete'
        ],
        description: 'Frontend delete button and JavaScript function'
    },
    {
        file: 'src/main/java/com/tas/spairparts/SparePartsViewController.java',
        patterns: [
            'model.addAttribute("isAdmin", isAdmin);',
            '"ADMIN".equals(user.getRole())',
            'model.addAttribute("userRole", user.getRole());'
        ],
        description: 'View controller admin status passing'
    }
];

let allPassed = true;

checks.forEach((check, index) => {
    console.log(`${index + 1}. Checking ${check.description}...`);
    
    try {
        const filePath = path.join(process.cwd(), check.file);
        const content = fs.readFileSync(filePath, 'utf8');
        
        const missing = check.patterns.filter(pattern => !content.includes(pattern));
        
        if (missing.length === 0) {
            console.log('   ✅ PASS - All required patterns found');
        } else {
            console.log('   ❌ FAIL - Missing patterns:');
            missing.forEach(pattern => console.log(`      - "${pattern}"`));
            allPassed = false;
        }
    } catch (error) {
        console.log(`   ❌ FAIL - File not found: ${check.file}`);
        allPassed = false;
    }
    
    console.log('');
});

console.log('========================================');
if (allPassed) {
    console.log('🎉 ALL CHECKS PASSED! Implementation is complete.');
    console.log('\n📋 Ready for testing:');
    console.log('1. Start app: mvn spring-boot:run');
    console.log('2. Login as admin: http://localhost:8082/login');
    console.log('3. Username: admin, Password: admin123');
    console.log('4. Look for delete buttons on dashboard');
} else {
    console.log('⚠️  Some checks failed. Please review the implementation.');
}
console.log('========================================');
