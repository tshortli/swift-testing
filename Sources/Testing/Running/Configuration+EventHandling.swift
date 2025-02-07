//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for Swift project authors
//

extension Configuration {
  /// Handle the specified event.
  ///
  /// - Parameters:
  ///   - event: The event to handle.
  ///   - context: The context associated with the event.
  ///
  /// This method is used to handle events which are generated by the testing
  /// library. Typically this only involves passing the event to this instance's
  /// `eventHandler` but this method may also be used as a customization point
  /// to change how the event is passed to the event handler.
  func handleEvent(_ event: borrowing Event, in context: borrowing Event.Context) {
    var contextCopy = copy context
    contextCopy.configuration = self
    contextCopy.configuration?.eventHandler = { _, _ in }

#if !SWT_NO_FILE_IO
    if case .valueAttached = event.kind {
      var eventCopy = copy event
      handleValueAttachedEvent(&eventCopy, in: context)
      return eventHandler(eventCopy, contextCopy)
    }
#endif

    return eventHandler(event, contextCopy)
  }
}
