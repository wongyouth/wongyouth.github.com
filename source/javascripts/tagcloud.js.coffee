$.fn.tagcloud.defaults = {
  size: {start: 14, end: 24, unit: 'pt'},
  color: {start: '#abc', end: '#f52'}
}

$ ->
  $('#tagcloud a').tagcloud()
