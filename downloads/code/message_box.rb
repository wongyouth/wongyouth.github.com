require 'fiddle'
require 'fiddle/import'
require 'fiddle/types'

module User32
	extend Fiddle::Importer

	dlload 'user32'

	include Fiddle::Win32Types # 增加一些常用的typealias
	typealias 'LPCTSTR', 'char*'

	extern 'int MessageBoxW(HWND, LPCTSTR, LPCTSTR, UINT)'
end

msg = 'Hello 你好'.encode('UTF-16LE')
User32.MessageBoxW(0, msg, msg, 0)
