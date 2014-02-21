#!/bin/sh

export YEAR=`date +"%Y"`
export DATE=`date +"%m/%d/%y"`
export USERNAME=$USER

if [ $# -lt 3 ]; then
    echo; echo "usage: ./create_project.sh <YourProjectName> <com.your.bundle.prefix> <PathToCreatedProject> [<AbsoluteEmbeddedFrameworkPath> <YourCompanyName>]"; echo
    exit 1
fi

export PRODUCT_NAME=$1
export BUNDLE_PREFIX=$2
export PROJECT_PATH=$3
DEFAULT_FRAMEWORK_PATH="/Users/Shared/Tibco/SilverMobile/Frameworks"
[[ $4 ]] && export EMBEDDED_FRAMEWORK_PATH="$4/SilverMobileCore.embeddedframework" || export EMBEDDED_FRAMEWORK_PATH="$DEFAULT_FRAMEWORK_PATH/SilverMobileCore.embeddedframework"
[[ $5 ]] && export COMPANY=$5 || export COMPANY="__MyCompanyName__"

export PACKAGE_NAME=$PRODUCT_NAME
export PRODUCT_NAME_AS_IDENTIFIER=$PRODUCT_NAME
export PACKAGE_NAME_AS_IDENTIFIER=$PRODUCT_NAME


if ! [ -e "$PROJECT_PATH" ]; then
    echo; echo "error: directory to create project in $PROJECT_PATH does not exist"; echo
    exit 1
fi

export DERIVED=`ls "/Users/$USER/Library/Developer/Xcode/DerivedData/" | egrep "($PRODUCT_NAME)-[a-z]+"`


if [ -n "$DERIVED" ]; then
    echo; echo "Deleting stale derived data: /Users/$USER/Library/Developer/Xcode/DerivedData/$DERIVED";
    rm -rf "/Users/$USER/Library/Developer/Xcode/DerivedData/$DERIVED"
else
    echo
fi

if ! [ -d "$PROJECT_PATH" ]; then
    echo; echo "error: path to create project in $PROJECT_PATH is not a directory"; echo
    exit 1
fi

if ! [ -e "$EMBEDDED_FRAMEWORK_PATH" ]; then
    echo
    echo "SilverMobileCore.embeddedframework does not exist at $EMBEDDED_FRAMEWORK_PATH"
    echo "Would you like to install it [Y/n]: \c"
    read -n1 INSTALL_FRAMEWORK
    echo
    if ( [[ $INSTALL_FRAMEWORK = "Y" ]] || [[ $INSTALL_FRAMEWORK = "y" ]] ); then
	SMFRAMEWORK="`pwd`/../SilverMobileCore.embeddedframework"
	if ! [ -e "$SMFRAMEWORK" ]; then
	    echo "SilverMobileCore.embeddedframework not found at $SMFRAMEWORK"
	    exit 1
	fi
	INSTALL_TO=$(dirname ${EMBEDDED_FRAMEWORK_PATH})
	mkdir -p $INSTALL_TO
	cp -r $SMFRAMEWORK $INSTALL_TO
    else
	echo "To create your first project either provide a valid absolute path to SilverMobileCore.embeddedframework or choose [Y|y] to install"
	echo
	exit 1
    fi
fi

if ! [ -d "$EMBEDDED_FRAMEWORK_PATH" ]; then
    echo; echo "error: SilverMobileCore.embeddedframework at $EMBEDDED_FRAMEWORK_PATH is not a directory"; echo
    exit 1
fi

echo "Creating Project: $BUNDLE_PREFIX.$PRODUCT_NAME in directory: $PROJECT_PATH"
echo "Using Embedded Framework at path $EMBEDDED_FRAMEWORK_PATH"

function replace_all_tokens {
    sed 's|___PACKAGENAMEASIDENTIFIER___|'"$PACKAGE_NAME_AS_IDENTIFIER"'|g
         s|___PROJECTNAME___|'"$PRODUCT_NAME"'|g
         s|___PRODUCTNAME___|'"$PRODUCT_NAME"'|g
         s|___PRODUCTNAMEASIDENTIFIER___|'"$PRODUCT_NAME_AS_IDENTIFIER"'|g
         s|___PROJECTNAMEASIDENTIFIER___|'"$PRODUCT_NAME_AS_IDENTIFIER"'|g
         s|___PACKAGENAMEASIDENTIFIER___|'"$PACKAGE_NAME_AS_IDENTIFIER"'|g
         s|___PACKAGENAME___|'"$PRODUCT_NAME"'|g
         s|___VARIABLE_bundleIdentifierPrefix:bundleIdentifier___|'"$BUNDLE_PREFIX"'|g
         s|___YEAR___|'"$YEAR"'|g
         s|___DATE___|'"$DATE"'|g
         s|___FULLUSERNAME___|'"$USERNAME"'|g
         s|___EMBEDDEDFRAMEWORKPATH___|'"$EMBEDDED_FRAMEWORK_PATH"'|g
         s|___PROJECTPATH___|'"$PROJECT_PATH"'|g
         s|___ORGANIZATIONNAME___|'"$COMPANY"'|g' "$1" > "$1.tmp" 
}

function transform {
    cp "$1" "$2"
    replace_all_tokens "$2"
    mv "$2.tmp" "$2"
}

if ! [ -e "template/___PACKAGENAMEASIDENTIFIER___AppDelegate.h" ]; then
    echo; echo "this script expects to be run from <SilverMobile Distribution Path>/bin"; echo
    exit 1
fi

mkdir -p "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/www"
cp -r "template/www" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/"
mkdir -p "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME.xcodeproj"

transform "template/___PACKAGENAMEASIDENTIFIER___AppDelegate.h" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/$PACKAGE_NAME_AS_IDENTIFIER""AppDelegate.h"
transform "template/___PACKAGENAMEASIDENTIFIER___AppDelegate.m" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/$PACKAGE_NAME_AS_IDENTIFIER""AppDelegate.m"
transform "template/main.m" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/main.m"
transform "template/___PACKAGENAME___-Info.plist" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/$PRODUCT_NAME-Info.plist"
transform "template/___PACKAGENAME___-Prefix.pch" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/$PRODUCT_NAME-Prefix.pch"
transform "template/___PACKAGENAME___.xcodeproj/project.pbxproj" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME.xcodeproj/project.pbxproj"
cp "template/Default-568h@2x.png" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/Default-568h@2x.png"
cp "template/Cordova.plist" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME"
cp "template/Default.png" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/Default.png"
cp "template/Default@2x.png" "$PROJECT_PATH/$PRODUCT_NAME/$PRODUCT_NAME/Default@2x.png"

echo
echo "Done."
