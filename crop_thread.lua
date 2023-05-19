-- crop_thread.lua

-- Get the phase_time from the thread arguments
local phase_time = ...

-- Function executed in the thread
function threadFunction()
    while true do
        phase_time = phase_time - 1

        if phase_time <= 0 then
            -- Phase time reached zero, perform actions or signal the main thread here
            break -- Exit the loop and terminate the thread
        end

        love.timer.sleep(1) -- Sleep for 1 second
    end
end

-- Call the thread function
threadFunction()