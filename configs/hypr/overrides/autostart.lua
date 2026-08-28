-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Night light. Omarchy leaves hyprsunset stopped and starts it on demand from
-- the toggle, which means a schedule would never fire on a day the toggle was
-- not touched. Launching it with the session is what makes the profiles in
-- hyprsunset.conf actually run.
o.launch_on_start("hyprsunset")
