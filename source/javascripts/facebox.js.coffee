#=require 'facebox/src/facebox'

$.facebox.settings.loadingImage = '/images/facebox/loading.gif'
$.facebox.settings.closeImage = '/images/facebox/closelabel.png'

$ ->
  $('a[rel*=facebox]').facebox()

