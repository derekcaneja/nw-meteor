ROOT=$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd );
NW_METEOR_ROOT=$(dirname "$ROOT");

# Directory where the meteor project is stored
METEOR_PROJECT_DIR="$NW_METEOR_ROOT/meteor-project";

# Meteor settings to compile app with
METEOR_SETTINGS=;
USE_SETTINGS=false;

# Whether or not to run meteor locally or from nw app
DEBUG_MODE=true;

function usage
{
  echo "Usage: build.sh [args]";

  echo "";
  echo "With no arguments, 'build-android.sh' will build the meteor project";
  echo "and run a local meteor server to debug the application locally.";

  echo "";
  echo "Options:";
  echo "    -m | --meteor-settings    Use a specified meteor settings.json."
  echo "    -r | --release            Build cordova application in release mode."
  echo "    -s | --server             Use a specified (non-local) server."
}

# Parse arguments
while [ "$1" != "" ]; do
    case $1 in
        -r | --release )          shift
                                  DEBUG_MODE=false
                                  ;;
        -m | --meteor-settings )  shift
                                  METEOR_SETTINGS=$1
                                  USE_SETTINGS=true
                                  ;;
        -h | --help )             usage
                                  exit
    esac
    shift
done

# Make lib directory if it doesn't exist and then download meteor and node-webkit-builder
if [ ! -d "$ROOT/lib" ]; then
  echo "Build dependencies not found... sit tight while we grab them";
  echo "";

  mkdir "$ROOT/lib";

  cd "$ROOT/lib";

  git clone https://github.com/meteor/meteor.git;
  $ROOT/lib/meteor/scripts/generate-dev-bundle.sh;
  ln -s "$ROOT/lib/meteor/meteor" "$ROOT/meteor";

  cd "$ROOT/lib";

  npm install node-webkit-builder;
  mv "$NW_METEOR_ROOT/node_modules" "$ROOT/lib/node_modules";
  ln -s "$ROOT/lib/node_modules/node-webkit-builder/bin/nwbuild" "$ROOT/nwbuild";

  # Update line endings for OSX
  sed -i -e $'s/\r//' "$ROOT/lib/node_modules/node-webkit-builder/bin/nwbuild";
fi


NW_BUILDER="$ROOT/nwbuild";
METEOR="$ROOT/meteor";

# Move to meteor project's root directory
cd $METEOR_PROJECT_DIR;

# Build meteor project with proper settings
if [ "$DEBUG_MODE" = true ]; then
  echo '';
  echo 'Starting meteor and nw application...';
  echo '';

  if [ "$USE_SETTINGS" = true ]; then
    $METEOR run --settings $METEOR_SETTINGS &
  else
    $METEOR run &
  fi

  export ENV=development;
  $NW_BUILDER -r $NW_METEOR_ROOT  1>/dev/null 2>&1
else
  echo '';
  echo 'Packaging meteor and nw application...';
  echo '';

  if [ ! -d "$NW_METEOR_ROOT/.release" ]; then
    mkdir $NW_METEOR_ROOT/.release;
  else
    rm -rf $NW_METEOR_ROOT/.release;
    mkdir $NW_METEOR_ROOT/.release;
  fi

  $NW_BUILDER -o $NW_METEOR_ROOT/.release $NW_METEOR_ROOT;

  # Copy meteor files that got left behind in the bundling process
  cp -a $METEOR_PROJECT_DIR/.meteor $NW_METEOR_ROOT/.release/nw-meteor/osx64/nw-meteor.app/Contents/Resources/app.nw/meteor-project/.meteor;
  cp -a $ROOT/lib/meteor $NW_METEOR_ROOT/.release/nw-meteor/osx64/nw-meteor.app/Contents/Resources/app.nw/meteor;

  # Copy icons for OSX
  cp -a $NW_METEOR_ROOT/img/icon.icns $NW_METEOR_ROOT/.release/nw-meteor/osx64/nw-meteor.app/Contents/Resources/nw.icns;
fi
