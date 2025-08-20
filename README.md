# Git Changes Zipper

A simple bash script to create zip archives of modified files between two git commits while preserving the original folder structure.

## 📋 Prerequisites

- Git repository (initialized and synchronized with GitHub)
- Bash shell
- `zip` utility (usually pre-installed on most Linux/macOS systems)

## 🚀 Setup

### 1. Add to Your Project

Clone or add this tool to your project folder that is synchronized with your GitHub repository:

```bash
# Option 1: Clone the repository into your project
git clone https://github.com/your-username/git-changes-zipper.git
cd git-changes-zipper

# Option 2: Download just the script file
wget https://raw.githubusercontent.com/your-username/git-changes-zipper/main/zip-modified.sh
# or
curl -O https://raw.githubusercontent.com/your-username/git-changes-zipper/main/zip-modified.sh
```

### 2. Make Script Executable

Give executable permissions to the script:

```bash
sudo chmod +x zip-modified.sh
```

## 📖 Usage

The script compares two commits and creates a zip file containing all modified files between them.

### Basic Syntax

```bash
./zip-modified.sh <start-commit-id> <end-commit-id> [--dry-run]
```

### Parameters

- **`start-commit-id`**: The starting commit hash (should be one commit **before** where you want to start checking)
- **`end-commit-id`**: The ending commit hash
- **`--dry-run`** (optional): Preview mode - shows what files would be zipped without creating the archive

### Examples

#### 1. Dry Run (Preview Mode)

Test what files would be included without creating a zip:

```bash
./zip-modified.sh abc123 def456 --dry-run
```

**Output:**
```
Files changed between abc123 and def456 (excluding specified files/dirs):
src/components/Header.js
src/styles/main.css
package.json
[Dry-run] Would zip these files while preserving folder structure.
```

#### 2. Create Zip Archive

Generate the actual zip file with modified files:

```bash
./zip-modified.sh abc123 def456
```

**Output:**
```
Files changed between abc123 and def456 (excluding specified files/dirs):
src/components/Header.js
src/styles/main.css
package.json
Created zip archive: changes_abc123_to_def456_20241201_143052.zip
```

## 🔍 Finding Commit IDs

### Method 1: Using git log
```bash
# View recent commits with short hashes
git log --oneline -10

# View detailed commit history
git log --graph --pretty=format:'%h - %an, %ar : %s'
```

### Method 2: Using GitHub Web Interface
1. Go to your repository on GitHub
2. Click on "Commits" tab
3. Copy the commit hash (first 7-8 characters are sufficient)

### Method 3: Using git reflog
```bash
# See recent HEAD movements
git reflog
```

## 📁 Output

The script creates a zip file with the following naming convention:
```
changes_<start-commit>_to_<end-commit>_<timestamp>.zip
```

**Example:** `changes_abc123_to_def456_20241201_143052.zip`

The zip file maintains the original folder structure of your project, so extracted files will be in their correct relative paths.

## 🚫 Excluded Files/Directories

The script automatically excludes the following files and directories:
- `public-old/` directory and its contents
- `.vscode/` directory and its contents  
- `.cursor/` directory and its contents
- `changes.sql` file
- `.gitignore` file

## 💡 Tips and Best Practices

### 1. Understanding Start Commit
⚠️ **Important:** The `start-commit-id` should be **one commit before** the actual starting point you want to check.

**Example scenario:**
- You want to see changes from commit `B` to commit `D`
- Use commit `A` as the start-commit-id
- Git diff will show: A → B → C → D (changes from A to D, which includes your desired B to D)

```
A (use this) → B (actual start) → C → D (end)
```

### 2. Always Test with Dry Run
```bash
# Always run dry-run first to preview
./zip-modified.sh abc123 def456 --dry-run

# If satisfied with the preview, run actual command
./zip-modified.sh abc123 def456
```

### 3. Using Short Commit Hashes
You don't need the full commit hash - first 7-8 characters are sufficient:
```bash
# Full hash (works)
./zip-modified.sh a1b2c3d4e5f6g7h8i9j0 x9y8z7w6v5u4t3s2r1q0

# Short hash (recommended)
./zip-modified.sh a1b2c3d x9y8z7w
```

## 🛠 Troubleshooting

### Error: "This is not a git repository"
**Solution:** Ensure you're running the script from within a git repository:
```bash
git status  # Verify you're in a git repo
```

### Error: "Start commit 'xyz' not found"
**Solution:** Verify the commit hash exists:
```bash
git log --oneline | grep xyz
# or
git show xyz
```

### Error: Permission denied
**Solution:** Make sure the script has executable permissions:
```bash
ls -la zip-modified.sh  # Check permissions
sudo chmod +x zip-modified.sh  # Add execute permission
```

### No files found between commits
This could mean:
1. The commits are identical
2. The start and end commits are in wrong order
3. All changes are in excluded directories

## 📝 License

[Add your license information here]

## 🤝 Contributing

[Add contribution guidelines here]

---

**Need help?** Open an issue in this repository or contact [your-email@example.com]
