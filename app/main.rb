def tick args
  if args.inputs.keyboard.key_down.enter
    args.gtk.notify_extended! message: "message to show", # message to show
                              durations: 120,             # how many ticks to show the message
                              env:       :prod,           # by default, notifications only happend in :dev
                              overwrite: true             # if this value is true, the notification will
                                                          # shown even if another one is currently in progress
  end
end
