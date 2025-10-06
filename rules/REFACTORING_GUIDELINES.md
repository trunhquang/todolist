# 🔄 Refactoring Guidelines

## 1. Safe Refactoring Steps
1. **Write tests first** for existing functionality
2. **Extract interfaces** for better testability
3. **Move code gradually** to new structure
4. **Update dependencies** one by one
5. **Run tests** after each change
6. **Update documentation**

## 2. Breaking Changes
- **Version bump** required for breaking changes
- **Migration guide** must be provided
- **Backward compatibility** maintained when possible
- **Team notification** before major refactoring

## 3. Code Quality Metrics
- **Test coverage**: Minimum 80%
- **Code complexity**: Maximum 10 per method
- **File size**: Maximum 400 lines
- **Method size**: Maximum 50 lines
- **Class size**: Maximum 200 lines
- **Widget size**: Maximum 100 lines per widget

---

**📁 File liên quan:**
- [Code Review Checklist](CODE_REVIEW_CHECKLIST.md)
- [Testing Rules](TESTING_RULES.md)
- [Coding Standards](CODING_STANDARDS.md)
