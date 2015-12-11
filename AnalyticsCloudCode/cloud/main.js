
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
