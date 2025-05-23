#!/bin/bash

# iOS プロジェクトセットアップスクリプト
# 使用方法: 
#   ./setup-project.sh YourNewProjectName com.yourcompany.yourappid
#   ./setup-project.sh YourNewProjectName com.yourcompany.yourappid --debug

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# デバッグモードの初期化
DEBUG_MODE=false

# 引数の解析
if [ "$#" -lt 2 ]; then
    echo -e "${RED}エラー: 必要な引数が不足しています。${NC}"
    echo "使用方法: ./setup-project.sh YourNewProjectName com.yourcompany.yourappid [--debug]"
    exit 1
fi

NEW_PROJECT_NAME=$1
NEW_BUNDLE_ID=$2

# デバッグモードの確認
if [ "$#" -ge 3 ] && [ "$3" == "--debug" ]; then
    DEBUG_MODE=true
    echo -e "${YELLOW}デバッグモードが有効です${NC}"
fi

# 変数の設定
CURRENT_DIR=$(pwd)
TEMPLATE_PROJECT_NAME="ios-project-template"
TEMPLATE_BUNDLE_ID="com.example.ios-project-template"

# 実行の確認
echo -e "${YELLOW}==== iOS プロジェクトセットアップ ====${NC}"
echo -e "テンプレート名: ${BLUE}$TEMPLATE_PROJECT_NAME${NC}"
echo -e "新プロジェクト名: ${GREEN}$NEW_PROJECT_NAME${NC}"
echo -e "新バンドルID: ${GREEN}$NEW_BUNDLE_ID${NC}"
if [ "$DEBUG_MODE" = true ]; then
    echo -e "モード: ${YELLOW}デバッグ${NC} (.gitディレクトリは保持されます)"
else
    echo -e "モード: 通常"
fi
echo
echo -e "${YELLOW}この設定でプロジェクトをセットアップしますか？ [y/N]${NC}"
read -r CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo -e "${RED}セットアップを中止しました。${NC}"
    exit 0
fi

echo -e "${YELLOW}セットアップを開始します...${NC}"

# スキームファイルの保存
echo -e "${BLUE}スキーム設定を保存中...${NC}"
SCHEME_DIR="./$TEMPLATE_PROJECT_NAME.xcodeproj/xcshareddata/xcschemes"
SCHEME_BACKUP_DIR="./scheme_backup"
if [ -d "$SCHEME_DIR" ]; then
    mkdir -p "$SCHEME_BACKUP_DIR"
    cp -R "$SCHEME_DIR"/* "$SCHEME_BACKUP_DIR"/
    echo "スキーム設定をバックアップしました: $SCHEME_BACKUP_DIR"
    
    # デバッグ用：バックアップされたスキームの確認
    ls -la "$SCHEME_BACKUP_DIR"
fi

# ディレクトリ名の変更
echo -e "${BLUE}ディレクトリ名を変更中...${NC}"
find . -type d -name "*$TEMPLATE_PROJECT_NAME*" -not -path "*/\.*" | while read -r dir; do
    NEW_DIR_NAME=$(echo "$dir" | sed "s/$TEMPLATE_PROJECT_NAME/$NEW_PROJECT_NAME/g")
    if [ "$dir" != "$NEW_DIR_NAME" ]; then
        mkdir -p "$(dirname "$NEW_DIR_NAME")"
        mv "$dir" "$NEW_DIR_NAME"
        echo "ディレクトリ移動: $dir → $NEW_DIR_NAME"
    fi
done

# App フォルダの特別処理：事前にApp.swiftファイルを特別に処理
echo -e "${BLUE}App ファイルの特別処理を実行中...${NC}"

# App.swift ファイルを検索（固定文字列で検索）
APP_SWIFT_FILE=$(find . -name "ios_project_templateApp.swift")
if [ -n "$APP_SWIFT_FILE" ]; then
    # ファイル名を出力（デバッグ用）
    echo "処理対象App ファイル: $APP_SWIFT_FILE"
    
    # 新しいファイル名を生成（App接尾辞なし）
    NEW_APP_SWIFT_FILE=$(echo "$APP_SWIFT_FILE" | sed "s/ios_project_templateApp.swift/${NEW_PROJECT_NAME}.swift/g")
    
    # App.swiftファイル内の構造体名を更新 - App接尾辞なしの構造体名に
    sed -i '' "s/struct ios_project_templateApp: App/struct ${NEW_PROJECT_NAME}: App/g" "$APP_SWIFT_FILE"
    echo "構造体名を更新: $APP_SWIFT_FILE"
    
    # App.swiftファイル名を変更
    mkdir -p "$(dirname "$NEW_APP_SWIFT_FILE")"
    mv "$APP_SWIFT_FILE" "$NEW_APP_SWIFT_FILE"
    echo "App ファイル名変更: $APP_SWIFT_FILE → $NEW_APP_SWIFT_FILE"
fi

# 残りのファイル名の変更（App.swiftを除く）
echo -e "${BLUE}ファイル名を変更中...${NC}"
find . -type f -not -path "*/\.git/*" -not -path "*/\.DS_Store" -not -path "*/.build/*" -not -path "*/scheme_backup/*" | while read -r file; do
    if [[ "$file" != *".swift"* ]] || [[ "$file" != *"$NEW_PROJECT_NAME.swift"* ]]; then
        NEW_FILE_NAME=$(echo "$file" | sed "s/$TEMPLATE_PROJECT_NAME/$NEW_PROJECT_NAME/g" | sed "s/ios_project_template/$NEW_PROJECT_NAME/g")
        if [ "$file" != "$NEW_FILE_NAME" ]; then
            mkdir -p "$(dirname "$NEW_FILE_NAME")"
            mv "$file" "$NEW_FILE_NAME"
            echo "ファイル移動: $file → $NEW_FILE_NAME"
        fi
    fi
done

# スキームファイルの復元
echo -e "${BLUE}スキーム設定を復元中...${NC}"
NEW_SCHEME_DIR="./$NEW_PROJECT_NAME.xcodeproj/xcshareddata/xcschemes"
if [ -d "$SCHEME_BACKUP_DIR" ]; then
    # スキームディレクトリの作成
    mkdir -p "$NEW_SCHEME_DIR"
    
    # バックアップからスキームファイルを復元
    for scheme_file in "$SCHEME_BACKUP_DIR"/*; do
        # スキームファイル名を抽出
        SCHEME_NAME=$(basename "$scheme_file")
        SCHEME_BASE_NAME=$(basename "$SCHEME_NAME" .xcscheme)
        
        # スキーム名を更新 (例：template-dev → MyApp-dev)
        NEW_SCHEME_BASE_NAME=$(echo "$SCHEME_BASE_NAME" | sed "s/^$TEMPLATE_PROJECT_NAME-/$NEW_PROJECT_NAME-/g" | sed "s/^template-/$NEW_PROJECT_NAME-/g")
        NEW_SCHEME_NAME="$NEW_SCHEME_BASE_NAME.xcscheme"
        
        echo "スキーム名変更: $SCHEME_BASE_NAME → $NEW_SCHEME_BASE_NAME"
        
        # スキームファイル内の参照を更新
        sed -i '' "s/$TEMPLATE_PROJECT_NAME/$NEW_PROJECT_NAME/g" "$scheme_file"
        
        # スキームファイル内のスキーム名も更新
        # <Scheme name="template-dev" ... > を <Scheme name="MyApp-dev" ... > に変更
        sed -i '' "s/name=\"$SCHEME_BASE_NAME\"/name=\"$NEW_SCHEME_BASE_NAME\"/g" "$scheme_file"
        sed -i '' "s/name=\"template-[^\"]*\"/name=\"$NEW_SCHEME_BASE_NAME\"/g" "$scheme_file"
        
        # ファイルを復元
        cp "$scheme_file" "$NEW_SCHEME_DIR/$NEW_SCHEME_NAME"
        echo "スキーム復元: $NEW_SCHEME_NAME"
    done
    
    # バックアップディレクトリの削除
    rm -rf "$SCHEME_BACKUP_DIR"
fi

# 一般的なファイル内容の置換
echo -e "${BLUE}ファイル内容を更新中...${NC}"
find . -type f -name "*.swift" -o -name "*.plist" -o -name "*.pbxproj" -o -name "*.xcscheme" -o -name "*.xcconfig" -o -name "*.xcsettings" -o -name "*.storyboard" -o -name "*.xib" -o -name "*.xcworkspacedata" -o -name "*.json" -o -name "*.md" -o -name "Package.swift" | xargs grep -l "$TEMPLATE_PROJECT_NAME\|ios_project_template\|$TEMPLATE_BUNDLE_ID" 2>/dev/null | while read -r file; do
    if [ -f "$file" ]; then
        sed -i '' "s/$TEMPLATE_PROJECT_NAME/$NEW_PROJECT_NAME/g" "$file"
        sed -i '' "s/ios_project_template/$NEW_PROJECT_NAME/g" "$file"
        sed -i '' "s/$TEMPLATE_BUNDLE_ID/$NEW_BUNDLE_ID/g" "$file"
        echo "更新: $file"
    fi
done

# template- で始まるスキームファイルを削除
echo -e "${BLUE}不要なスキームファイルを削除中...${NC}"
find . -name "template-*.xcscheme" | while read -r template_scheme; do
    echo "削除: $template_scheme"
    rm -f "$template_scheme"
done

# Project.pbxproj ファイルの処理（特殊なケース用）
PBXPROJ_FILES=$(find . -name "project.pbxproj")
for file in $PBXPROJ_FILES; do
    if [ -f "$file" ]; then
        # ファイル参照名の変更（ios_project_templateApp.swift → NewProjectName.swift）
        sed -i '' "s/ios_project_templateApp.swift/${NEW_PROJECT_NAME}.swift/g" "$file"
        # 通常の置換
        sed -i '' "s/$TEMPLATE_PROJECT_NAME/$NEW_PROJECT_NAME/g" "$file"
        sed -i '' "s/$TEMPLATE_BUNDLE_ID/$NEW_BUNDLE_ID/g" "$file"
        echo "プロジェクトファイル更新: $file"
    fi
done

# Info.plist ファイルの更新
INFO_PLIST_FILES=$(find . -name "Info.plist")
for file in $INFO_PLIST_FILES; do
    if [ -f "$file" ]; then
        sed -i '' "s/$TEMPLATE_BUNDLE_ID/$NEW_BUNDLE_ID/g" "$file"
        echo "Info.plist 更新: $file"
    fi
done

# Xcode ワークスペースの更新
WORKSPACE_FILES=$(find . -name "*.xcworkspace" -type d)
for workspace in $WORKSPACE_FILES; do
    CONTENTS_FILE="$workspace/contents.xcworkspacedata"
    if [ -f "$CONTENTS_FILE" ]; then
        sed -i '' "s/$TEMPLATE_PROJECT_NAME/$NEW_PROJECT_NAME/g" "$CONTENTS_FILE"
        echo "ワークスペース更新: $CONTENTS_FILE"
    fi
done

# パッケージ依存関係の解決
echo -e "${BLUE}パッケージ依存関係を解決中...${NC}"

# .git ディレクトリの処理（デバッグモードでない場合のみ削除）
if [ "$DEBUG_MODE" = false ]; then
    echo -e "${YELLOW}古い .git ディレクトリを削除中...${NC}"
    rm -rf .git
    
    # 新しい Git リポジトリの初期化
    echo -e "${BLUE}新しい Git リポジトリを初期化中...${NC}"
    git init
    git add .
    git commit -m "Initial commit - Project set up from template"
else
    echo -e "${YELLOW}デバッグモード: .git ディレクトリを保持します${NC}"
fi

# Swift パッケージを解決
echo -e "${BLUE}Swift パッケージを解決中...${NC}"
find . -name "Package.swift" -not -path "*/\.build/*" | while read -r package_file; do
    PACKAGE_DIR=$(dirname "$package_file")
    (cd "$PACKAGE_DIR" && swift package resolve)
    echo "パッケージ解決: $package_file"
done

# プロジェクトのクリーン化
echo -e "${BLUE}プロジェクトをクリーニング中...${NC}"
find . -name ".build" -type d -exec rm -rf {} +
find . -name "DerivedData" -type d -exec rm -rf {} +
find . -name ".DS_Store" -type f -delete

# 必要なファイルをTemplateから移動し、重複を解消
echo -e "${BLUE}プロジェクトファイルを整理中...${NC}"
if [ -d "./Template/$NEW_PROJECT_NAME" ]; then
    # ルートにある重複したディレクトリを削除（既にあれば）
    if [ -d "./App" ]; then rm -rf ./App; fi
    if [ -d "./AppIcon" ]; then rm -rf ./AppIcon; fi
    if [ -d "./Configurations" ]; then rm -rf ./Configurations; fi
    if [ -d "./Privacy" ]; then rm -rf ./Privacy; fi
    if [ -d "./Sources" ]; then rm -rf ./Sources; fi
    
    # プロジェクトディレクトリをTemplateからルートにコピー
    # ここが重要: プロジェクト名ディレクトリ自体をコピー
    cp -R ./Template/$NEW_PROJECT_NAME .
    echo "プロジェクトディレクトリをルートにコピーしました"
    
    # Xcodeプロジェクトファイルを移動
    if [ -d "./Template/$NEW_PROJECT_NAME.xcodeproj" ]; then
        cp -R ./Template/$NEW_PROJECT_NAME.xcodeproj .
        echo "Xcodeプロジェクトファイルをルートに移動しました"
    fi
    
    # テストディレクトリを移動
    if [ -d "./Template/${NEW_PROJECT_NAME}Tests" ]; then
        cp -R ./Template/${NEW_PROJECT_NAME}Tests .
        echo "テストディレクトリをルートに移動しました"
    fi
    
    # UIテストディレクトリを移動
    if [ -d "./Template/${NEW_PROJECT_NAME}UITests" ]; then
        cp -R ./Template/${NEW_PROJECT_NAME}UITests .
        echo "UIテストディレクトリをルートに移動しました"
    fi
    
    # 不要なディレクトリを削除
    echo -e "${BLUE}不要なディレクトリを削除中...${NC}"
    rm -rf ./Template
    rm -rf ./Example
    
    # ワークスペースの処理
    if [ "$DEBUG_MODE" = false ]; then
        # 通常モード: ルートにあるワークスペースを削除
        find . -name "*.xcworkspace" -type d -maxdepth 1 -exec rm -rf {} \;
        echo "xcworkspaceファイルを削除しました"
    else
        # デバッグモード: ワークスペースを保持
        echo -e "${YELLOW}デバッグモード: xcworkspaceファイルを保持します${NC}"
    fi
    echo "ファイル整理が完了しました"
else
    echo -e "${RED}Templateディレクトリ内のプロジェクトが見つかりません。${NC}"
fi

# セットアップスクリプト自体の処理（デバッグモードでない場合のみ削除）
if [ "$DEBUG_MODE" = false ]; then
    echo -e "${BLUE}セットアップスクリプトを削除中...${NC}"
    rm -f setup-project.sh
else
    echo -e "${YELLOW}デバッグモード: セットアップスクリプトを保持します${NC}"
fi

echo -e "${GREEN}=====================================${NC}"
echo -e "${GREEN}セットアップが完了しました！${NC}"
echo -e "${GREEN}新プロジェクト名: $NEW_PROJECT_NAME${NC}"
echo -e "${GREEN}新バンドルID: $NEW_BUNDLE_ID${NC}"
if [ "$DEBUG_MODE" = true ]; then
    echo -e "${YELLOW}デバッグモードで実行されました${NC}"
fi
echo -e "${GREEN}=====================================${NC}"
echo
echo -e "${YELLOW}次のステップ:${NC}"
echo -e "1. Xcode でプロジェクトを開く: ${BLUE}open $NEW_PROJECT_NAME.xcodeproj${NC}"
echo -e "2. 'Build and Run' を実行してプロジェクトが正常に機能することを確認"
if [ "$DEBUG_MODE" = false ]; then
    echo -e "3. 必要に応じてリモートリポジトリを設定: ${BLUE}git remote add origin <your-repo-url>${NC}"
fi