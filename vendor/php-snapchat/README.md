Snapchat for PHP
================

This library is built to communicate with the Snapchat API. So far it supports
logging in/out, fetching snaps, downloading snaps, marking snaps viewed,
uploading snaps, and sending snaps.

It's similar to the [excellent Snaphax library](http://github.com/tlack/snaphax)
built by Thomas Lackner <[@tlack](http://twitter.com/tlack)>, but the approach
is different enough that I figured it deserved its own repo.


Usage
-----

Include src/snapchat.php via require_once or Composer or whatever, then:

```php
<?php

// Log in:
$snapchat = new Snapchat('username', 'password');

// Get your feed:
$snaps = $snapchat->getSnaps();

// Download a specific snap:
$data = $snapchat->getMedia('122FAST2FURIOUS334r');
file_put_contents('/home/dan/snap.jpg', $data);

// Mark the snap as viewed:
$snapchat->markSnapViewed('122FAST2FURIOUS334r');

// Screenshot!
$snapchat->markSnapShot('122FAST2FURIOUS334r');

// Upload a snap and send it to me for 8 seconds:
$id = $snapchat->upload(
	Snapchat::MEDIA_IMAGE,
	file_get_contents('/home/dan/whatever.jpg')
);
$snapchat->send($id, array('stelljes'), 8);

// Destroy the evidence:
$snapchat->clearFeed();

// Get a list of your friends:
$friends = $snapchat->getFriends();

// Add some people as friends:
$snapchat->addFriends(array('bill', 'bob', 'bart'));

// Get a list of the people you've added:
$added = $snapchat->getAddedFriends();

// Find out who Bill and Bob snap the most:
$bests = $snapchat->getBests(array('bill', 'bob'));

// Set Bart's display name:
$snapchat->setDisplayName('bart', 'Barty');

// Block Bart:
$snapchat->block('bart');

// Unblock Bart:
$snapchat->unblock('bart');

// Delete Bart entirely:
$snapchat->deleteFriends(array('bart'));

// You only want your friends to be able to snap you:
$snapchat->updatePrivacy(Snapchat::PRIVACY_FRIENDS);

// You want to change your email:
$snapchat->updateEmail('dan@example.com');

// Log out:
$snapchat->logout();

?>
```


Documentation
------------

There is none, but I tried to mark up the code well enough to make up for it.
Error handling is pretty weak, so watch for that.


License
------------

MIT
