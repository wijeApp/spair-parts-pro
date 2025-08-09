package com.tas.spairparts.model;

/**
 * Represents categories for organizing spare parts
 */
public class Category {
    private Long id;
    private String categoryCode;
    private String categoryName;
    private String description;
    private Long parentCategoryId;
    private boolean isActive;
    private int sortOrder;

    // Default constructor
    public Category() {
        this.isActive = true;
        this.sortOrder = 0;
    }

    // Constructor with essential fields
    public Category(String categoryCode, String categoryName) {
        this();
        this.categoryCode = categoryCode;
        this.categoryName = categoryName;
    }

    // Constructor with parent category
    public Category(String categoryCode, String categoryName, Long parentCategoryId) {
        this(categoryCode, categoryName);
        this.parentCategoryId = parentCategoryId;
    }

    // Method to check if this is a root category
    public boolean isRootCategory() {
        return parentCategoryId == null;
    }

    // Method to check if this is a subcategory
    public boolean isSubCategory() {
        return parentCategoryId != null;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getParentCategoryId() {
        return parentCategoryId;
    }

    public void setParentCategoryId(Long parentCategoryId) {
        this.parentCategoryId = parentCategoryId;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", categoryCode='" + categoryCode + '\'' +
                ", categoryName='" + categoryName + '\'' +
                ", parentCategoryId=" + parentCategoryId +
                ", isActive=" + isActive +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Category category = (Category) o;
        return categoryCode != null ? categoryCode.equals(category.categoryCode) : category.categoryCode == null;
    }

    @Override
    public int hashCode() {
        return categoryCode != null ? categoryCode.hashCode() : 0;
    }
}
