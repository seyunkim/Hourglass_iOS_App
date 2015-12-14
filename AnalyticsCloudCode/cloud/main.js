
// Log a tap event that does not have outside implications
// Required
//// (String) time = The recorded time of the tap event occuring on the local device
//// (String) userName = The username of the user who initiated this event
//// (String) screenName = The identifier for the currently displayed screen
//// (Number) xPos = The X position of the recorded tap (Low = Left, High = Right)
//// (Number) yPos = The Y position of the recorded tap (Low = Top, High = Bottom)
Parse.Cloud.define("logTapEvent", function(request, response) {
  var TapEventClass = Parse.Object.extend("TapEvent");
  var tapEvent = new TapEventClass();
  tapEvent.set("occurrenceTime", request.params.time);
  tapEvent.set("userName", request.params.userName);
  tapEvent.set("screenName", request.params.screenName);
  tapEvent.set("xPos", request.params.xPos);
  tapEvent.set("yPos", request.params.yPos);
  tapEvent.save(null, {
      success: function(savedTapEvent) {
        response.success();
      },
      error: function (savingError) {
        response.error(error);
      }
  });
});

// Log a screen load event
// Required
//// (String) time = The recorded time of the screen load event occuring on the local device
//// (String) userName = The username of the user who initiated this event
//// (String) screenName = The identifier for the newly displayed screen
Parse.Cloud.define("logScreenLoadEvent", function(request, response) {
  var ScreenLoadClass = Parse.Object.extend("ScreenLoadEvent");
  var screenLoad = new ScreenLoadClass();
  screenLoad.set("occurrenceTime", request.params.time);
  screenLoad.set("userName", request.params.userName);
  screenLoad.set("screenName", request.params.screenName);
  screenLoad.save(null, {
      success: function(savedScreenLoad) {
        response.success();
      },
      error: function (savingError) {
        response.error(error);
      }
  });
});

// Log a button press event
// Required
//// (String) time = The recorded time of the button press event occuring on the local device
//// (String) userName = The username of the user who initiated this event
//// (String) screenName = The identifier for the currently displayed screen
//// (String) buttonIdentifier = The identifier for the button that was pressed
Parse.Cloud.define("logButtonPressEvent", function(request, response) {
  var ButtonPressClass = Parse.Object.extend("ButtonPressEvent");
  var buttonPress = new ButtonPressClass();
  buttonPress.set("occurrenceTime", request.params.time);
  buttonPress.set("userName", request.params.userName);
  buttonPress.set("screenName", request.params.screenName);
  buttonPress.set("buttonIdentifier", request.params.buttonIdentifier);
  buttonPress.save(null, {
      success: function(savedButtonPress) {
        response.success();
      },
      error: function (savingError) {
        response.error(error);
      }
  });
});

// Log an enter background event
// Required
//// (String) time = The recorded time of the enter background event occuring on the local device
//// (String) userName = The username of the user who initiated this event
//// (String) screenName = The identifier for the currently displayed screen
Parse.Cloud.define("logEnterBackgroundEvent", function(request, response) {
  var EnterBackgroundClass = Parse.Object.extend("EnterBackgroundEvent");
  var enterBackground = new EnterBackgroundClass();
  enterBackground.set("occurrenceTime", request.params.time);
  enterBackground.set("userName", request.params.userName);
  enterBackground.set("screenName", request.params.screenName);
  enterBackground.save(null, {
      success: function(savedEnterBackground) {
        response.success();
      },
      error: function (savingError) {
        response.error(error);
      }
  });
});

// Log a special event
// Required
//// (String) time = The recorded time of the special event occuring on the local device
//// (String) userName = The username of the user who initiated this event
//// (String) screenName = The identifier for the currently displayed screen
//// (String) eventName = The identifier for the special event
//// (String) details = Any additional details about the event
Parse.Cloud.define("logSpecialEvent", function(request, response) {
  var SpecialEventClass = Parse.Object.extend("SpecialEvent");
  var specialEvent = new SpecialEventClass();
  specialEvent.set("occurrenceTime", request.params.time);
  specialEvent.set("userName", request.params.userName);
  specialEvent.set("screenName", request.params.screenName);
  specialEvent.set("eventName", request.params.eventName);
  specialEvent.set("details", request.params.details);
  specialEvent.save(null, {
      success: function(savedSpecial) {
        response.success();
      },
      error: function (savingError) {
        response.error(error);
      }
  });
});
