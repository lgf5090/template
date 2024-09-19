# template
## 如何发布新的版本
```bash
git tag -a v0.1.0 -m "Release version 0.1.0" HEAD
git push origin v0.1.0  # push所有标签
git push origin --tags  # push所有标签
git push origin --all   # push所有分支和标签

git tag -d v0.1.0       # 删除指定标签
```
