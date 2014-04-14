#= require qrcodejs/qrcode

$ ->
  new QRCode($('#qrcode').get(0), window.location.href)

