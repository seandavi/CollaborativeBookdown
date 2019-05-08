.readVignette = function(rmdfile) {
  readLines(rmdfile)
}

.getFirstLevelHeaderLines = function(txt) {
  return(grep('^# ', txt))
}

.checkForMultipleFirstLevelHeaders = function(txt) {
  lineNumbers = .getFirstLevelHeaderLines(txt)
  headerLineCount = length(lineNumbers)
  if(headerLineCount<1) {
    stop("must have one first-level header in rmarkdown: none found")
  }
  if(headerLineCount>1) {
    stop(sprintf("only one line may have a first-level header. Found multiple \nlines [%s].", 
                 paste(lineNumbers, collapse=", ")))
  }
}

fixMultipleFirstLevelHeaders = function(rmdfile) {
  txt = .readVignette(rmdfile)
  firstLevelHeaderLines = .getFirstLevelHeaderLines(txt)
  txt[firstLevelHeaderLines[2:length(firstLevelHeaderLines)]] = sapply(
    txt[firstLevelHeaderLines[2:length(firstLevelHeaderLines)]], function(line) {
      return(sub('^#', '##', line))
    }
  )
  return(txt)
}


checkVignette = function(rmdfile) {
  lines = .readVignette(rmdfile)
  .checkForMultipleFirstLevelHeaders(lines)
}