
info "Configuring iTerm..."

if ! [ -e /Applications/iTerm.app ]; then
  warning "Could not find iTerm.app. Please install iTerm and run this again."
else

  # iTerm config files location
  iTermConfig="${baseDir}/config/iTerm"

  if [ -d "${iTermConfig}" ]; then

    # 1. Copy fonts
    fontLocation="$HOME/Library/Fonts"
    for font in $iTermConfig/fonts/**/*.otf; do
      baseFontName=$(basename "$font")
      destFile="${fontLocation}/${baseFontName}"
      if [ ! -e "$destFile" ]; then
        execute "cp '${font}' '$destFile'"
      fi
    done

    # 2. symlink preferences
    sourceFile="${iTermConfig}/com.googlecode.iterm2.plist"
    destFile="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

    if [ ! -e "$destFile" ]; then
      execute "cp $sourceFile $destFile" "cp $sourceFile → $destFile"
    elif [ -h "$destFile" ]; then
      originalFile=$(locateSourceFile "$destFile")
      backupOriginalFile "$originalFile"
      if ! $dryrun; then rm -rf "$destFile"; fi
      execute "cp $sourceFile $destFile" "cp $sourceFile → $destFile"
    elif [ -e "$destFile" ]; then
      backupOriginalFile "$destFile"
      if ! $dryrun; then rm -rf "$destFile"; fi
      execute "cp $sourceFile $destFile" "cp $sourceFile → $destFile"
    else
      warning "Error linking: $sourceFile → $destFile"
    fi

    #3 Install preferred colorscheme
    execute "open ${baseDir}/config/iTerm/themes/dotfiles.itermcolors" "Installing preferred color scheme"
  else
    warning "Couldn't find iTerm configuration files"
  fi
fi