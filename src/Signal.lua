local Connection = {}
Connection.__index = Connection

function Connection.new(signal, handler, options)
	return setmetatable({
		signal = signal,
		connected = true,
		_handler = handler,
		_options = options or {},
	}, Connection)
end

function Connection:call(...)
	if self._options.disconnectAfterCall then
		self:disconnect()
	end

	self._handler(...)
end

function Connection:disconnect()
	if self.connected then
		self.connected = false

		for index, connection in pairs(self.signal._connections) do
			if connection == self then
				table.remove(self.signal._connections, index)
				return
			end
		end
	end
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_connections = {},
		_threads = {},
	}, Signal)
end

function Signal:fire(...)
	for _, connection in pairs(self._connections) do
		connection:call(...)
	end

	for _, thread in pairs(self._threads) do
		coroutine.resume(thread, ...)
	end
	
	self._threads = {}
end

function Signal:connect(handler, options)
	local connection = Connection.new(self, handler, options)
	table.insert(self._connections, connection)
	return connection
end

function Signal:once(handler)
	return self:connect(handler, {
		disconnectAfterCall = true,
	})
end

function Signal:wait()
	table.insert(self._threads, coroutine.running())
	return coroutine.yield()
end

return Signal