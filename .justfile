spellcheck:
  hunspell -d en_GB content/post/*.md

serve *args:
  hugo server -DEF --disableFastRender --cleanDestinationDir --gc {{args}}
