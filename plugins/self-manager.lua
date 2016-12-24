-- Checks if bot was disabled on specific chat
local function is_channel_disabled( receiver )
	if not _config.disabled_channels then
		return false
	end

	if _config.disabled_channels[receiver] == nil then
		return false
	end

  return _config.disabled_channels[receiver]
end

local function enable_channel(receiver)
	if not _config.disabled_channels then
		_config.disabled_channels = {}
	end

	if _config.disabled_channels[receiver] == nil then
		return "Self Is Not Off :)"
	end
	
	_config.disabled_channels[receiver] = false

	save_config()
	return "Self Is On Now :D"
end

local function disable_channel( receiver )
	if not _config.disabled_channels then
		_config.disabled_channels = {}
	end
	
	_config.disabled_channels[receiver] = true

	save_config()
	return "Self Is Off Now :/"
end

local function pre_process(msg)
	local receiver = get_receiver(msg)
	
	-- If sender is moderator then re-enable the channel
	if is_sudo(msg) then
	  if msg.text == "/self on" or msg.text == "/Self on" or msg.text == "!self on" or msg.text == "!Self on" then
	  
	    enable_channel(receiver)
	  end
	end

  if is_channel_disabled(receiver) then
  	msg.text = ""
  end
-----------------------
         local autoleave = 'autoleave'
         local bot_id = our_id 
         local receiver = get_receiver(msg)
           if not redis:get(autoleave) then
    if msg.service and msg.action.type == "chat_add_user" and msg.action.user.id == tonumber(bot_id) and not is_sudo(msg) then
       send_large_msg(receiver, "Don't Invite Me.", ok_cb, false)
       chat_del_user(receiver, 'user#id'..bot_id, ok_cb, false)
	   leave_channel(receiver, ok_cb, false)
    end
end
	return msg
end
-------------------
local function run(msg, matches)
	local receiver = get_receiver(msg)
	-- Enable a channel
	
	local hash = 'usecommands:'..msg.from.id..':'..msg.to.id
    redis:incr(hash)
	if not is_sudo(msg) then
	return nil
	end
	if matches[1] == 'on' then
		return enable_channel(receiver)
	end
	-- Disable a channel
	if matches[1] == 'off' then
		return disable_channel(receiver)
	end
	           ---------------------

-----------------------
     if matches[1] == 'autoleave' and is_sudo(msg) then
local hash = 'autoleave'
--Enable Auto Leave
     if matches[2] == 'enable' then
    redis:del(hash)
   return 'Auto leave has been enabled'
--Disable Auto Leave
     elseif matches[2] == 'disable' then
    redis:set(hash, true)
   return 'Auto leave has been disabled'
--Auto Leave Status
      elseif matches[2] == 'status' then
      if not redis:get(hash) then
   return 'Auto leave is enable'
       else
   return 'Auto leave is disable'
         end
      end
   end
end

return {
	description = "Plugin to manage channels. Enable or disable channel.", 
	usage = {
		"/channel enable: enable current channel",
		"/channel disable: disable current channel" },
	patterns = {
		"^[!/#](autoleave) (.*)$",
		"^[!/][Ss]elf (on)",
		"^[!/][Ss]elf (off)" }, 
	run = run,
	--privileged = true,
	moderated = true,
	pre_process = pre_process
}
