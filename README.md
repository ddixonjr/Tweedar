<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
</head>
<body>
<h1>Tweedar</h1>
<p>Tweedar is a simple but cool demo/portfolio app that displays up to 100 tweets near your current location.  I coded it in response to a code challenge and, in line with good OO and iOS design patterns, created a clean separation of view/view controller responsibilties from those of the network interaction and model.</p>
<p>The class reference documentation below describes those responsibilities along with the APIs that facilitate interaction between the classes that make up the app.</p>
<p><br></p>
<h2>TDRTweetsController Class Reference</h2>
<table cellspacing="0" cellpadding="0" class="t1">
  <tbody>
    <tr>
      <td valign="top" class="td1">
        <p class="p2"><b>Inherits from</b></p>
      </td>
      <td valign="top" class="td2">
        <p class="p2">NSObject</p>
      </td>
    </tr>
    <tr>
      <td valign="top" class="td1">
        <p class="p2"><b>Declared in</b></p>
      </td>
      <td valign="top" class="td2">
        <p class="p2">TDRTweetsController.h</p>
        <p class="p2">TDRTweetsController.m</p>
      </td>
    </tr>
  </tbody>
</table>
<p class="p3"><br></p>
<p class="p4"><b>Overview</b></p>
<p class="p5">A controller class that abstracts the interaction with the Twitter API. It facilitates querying of Tweets within a certain proximity, retrieving individual TDRTweet instances, marking tweets as favorites, and revoking tweets as no longer being favorites. It was built to separate the functionality from and act as a service to view controllers in providing Twitter integration capabilities.</p>
<p class="p4"><b>Tasks</b></p>
<ul class="ul1">
  <li class="li6">  delegate<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">  currentNumberOfTweets<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">– tweetAtIndex:</li>
  <li class="li6">– startUpdatingTweetsForNewCoordinate:</li>
  <li class="li6">– toggleFavoriteForTweet:inBackgroundWithBlock:</li>
  <li class="li6">– isFavoritedTweet:</li>
</ul>
<p class="p3"><br></p>
<p class="p4"><b>Properties</b></p>
<p class="p7">currentNumberOfTweets</p>
<p class="p8">The number of tweets currently loaded and managed by an instance of TDRTweetsController.</p>
<p class="p9">@property (assign, nonatomic) NSInteger currentNumberOfTweets</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">The number of tweets currently loaded and managed by an instance of TDRTweetsController.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p12"><br></p>
<p class="p7">delegate</p>
<p class="p8">Reference to the object assigned to be the delegate of an instance of TDRTweetsController.</p>
<p class="p9">@property (weak, nonatomic) id&lt;TweetControllerDelegate&gt; delegate</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">Reference to the object assigned to be the delegate of an instance of TDRTweetsController.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p3"><br></p>
<p class="p4">Instance Methods</p>
<p class="p7">isFavoritedTweet:</p>
<p class="p8">Queries the local store of favorited tweet IDs to determine whether or not the tweet passed in is has been favorited.</p>
<p class="p9">- (BOOL)isFavoritedTweet:(TDRTweet *)<i>tweet</i></p>
<p class="p10"><b>Parameters</b></p>
<p class="p13">tweet</p>
<p class="p8">The TDRTweet instance containing the ID needed to determine whether or not the tweet has been favorited.</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">Queries the local store of favorited tweet IDs to determine whether or not the tweet passed in is has been favorited.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p12"><br></p>
<p class="p7">startUpdatingTweetsForNewCoordinate:</p>
<p class="p8">Instructs the TDRTweetsController to query Twitter for tweets within a certain proximity of a specified geolocation.</p>
<p class="p9">- (void)startUpdatingTweetsForNewCoordinate:(CLLocationCoordinate2D)<i>coordinate</i></p>
<p class="p10"><b>Parameters</b></p>
<p class="p13">coordinate</p>
<p class="p8">The CLLocationCoordinate2D struct containing the target center geolocation around which the tweets should be located.</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">Instructs the TDRTweetsController to query Twitter for tweets within a certain proximity of a specified geolocation.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p12"><br></p>
<p class="p7">toggleFavoriteForTweet:inBackgroundWithBlock:</p>
<p class="p8">Uses the Twitter Framework to toggle the favorite status of a tweet for the user currently logged.</p>
<p class="p9">- (void)toggleFavoriteForTweet:(TDRTweet *)<i>tweet</i> inBackgroundWithBlock:(void ( ^ ) ( BOOL success , NSError *error ))<i>completion</i></p>
<p class="p10"><b>Parameters</b></p>
<p class="p13">tweet</p>
<p class="p8">The TDRTweet instance containing the ID needed to invoke the Twitter API call on the correct tweet.</p>
<p class="p13">completion</p>
<p class="p8">The block called after a response has been received from the Twitter Framework.</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">Uses the Twitter Framework to toggle the favorite status of a tweet for the user currently logged.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p12"><br></p>
<p class="p7">tweetAtIndex:</p>
<p class="p8">Retrieves the data model object that represents a single tweet in the current pool of tweets managed by TDRTweetsController.</p>
<p class="p9">- (TDRTweet *)tweetAtIndex:(NSInteger)<i>index</i></p>
<p class="p10"><b>Parameters</b></p>
<p class="p13">index</p>
<p class="p8">The index of the tweet object in the current pool of tweets.</p>
<p class="p10"><b>Return Value</b></p>
<p class="p8">The instance of a TDRTweet at the index specified in the index parameter.</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">Retrieves the data model object that represents a single tweet in the current pool of tweets managed by TDRTweetsController.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p14"><br></p>
<p class="p14"><br></p>
<p class="p14"><br></p>
<h2>TweetControllerDelegate Protocol Reference</h2>
<table cellspacing="0" cellpadding="0" class="t1">
  <tbody>
    <tr>
      <td valign="top" class="td3">
        <p class="p2"><b>Conforms to</b></p>
      </td>
      <td valign="top" class="td4">
        <p class="p2">NSObject</p>
      </td>
    </tr>
    <tr>
      <td valign="top" class="td3">
        <p class="p2"><b>Declared in</b></p>
      </td>
      <td valign="top" class="td4">
        <p class="p2">TDRTweetsController.h</p>
      </td>
    </tr>
  </tbody>
</table>
<p class="p3"><br></p>
<p class="p4"><b>Overview</b></p>
<p class="p5">A protocol to allow instances of TDRTweetsController to loosely communicate certain changes in state with its delegate object.</p>
<p class="p4"><b>Tasks</b></p>
<ul class="ul1">
  <li class="li6">– tweetsDidChangeInTweetsController:<span class="s2"> </span><span class="s3">required method</span></li>
  <li class="li6">– didObtainTwitterAccountInTweetsController:</li>
  <li class="li6">– didFailToObtainTwitterAccountInTweetsController:</li>
</ul>
<p class="p3"><br></p>
<p class="p4"><b>Instance Methods</b></p>
<p class="p7">didFailToObtainTwitterAccountInTweetsController:</p>
<p class="p8">A delegate method called to indicate when user permission to access Twitter accounts has failed.</p>
<p class="p9">- (void)didFailToObtainTwitterAccountInTweetsController:(TDRTweetsController *)<i>tweetsController</i></p>
<p class="p10"><b>Parameters</b></p>
<p class="p13">tweetsController</p>
<p class="p8">The instance of TDRTweetController that attempted the authorization.</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">A delegate method called to indicate when user permission to access Twitter accounts has failed.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p12"><br></p>
<p class="p7">didObtainTwitterAccountInTweetsController:</p>
<p class="p8">A delegate method called to indicate when user permission to access Twitter accounts has completed.</p>
<p class="p9">- (void)didObtainTwitterAccountInTweetsController:(TDRTweetsController *)<i>tweetsController</i></p>
<p class="p10"><b>Parameters</b></p>
<p class="p13">tweetsController</p>
<p class="p8">The instance of TDRTweetController that completed the authorization.</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">A delegate method called to indicate when user permission to access Twitter accounts has completed.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p12"><br></p>
<p class="p7">tweetsDidChangeInTweetsController:</p>
<p class="p8">A delegate method called to indicate when a request for tweets (as started by a call to the startUpdatingTweetsForNewCoordinate: method) has completed.</p>
<p class="p9">- (void)tweetsDidChangeInTweetsController:(TDRTweetsController *)<i>tweetsController</i></p>
<p class="p10"><b>Parameters</b></p>
<p class="p13">tweetsController</p>
<p class="p8">The instance of TDRTweetController that completed the query.</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">A delegate method called to indicate when a request for tweets (as started by a call to the startUpdatingTweetsForNewCoordinate: method) has completed.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetsController.h</p>
<p class="p14"><br></p>
<p class="p14"><br></p>
<p class="p14"><br></p>
<p class="p14"><br></p>
<p class="p14"><br></p>
<h2>TDRTweet Class Reference</h2>
<table cellspacing="0" cellpadding="0" class="t1">
  <tbody>
    <tr>
      <td valign="top" class="td1">
        <p class="p2"><b>Inherits from</b></p>
      </td>
      <td valign="top" class="td5">
        <p class="p2">NSObject</p>
      </td>
    </tr>
    <tr>
      <td valign="top" class="td1">
        <p class="p2"><b>Declared in</b></p>
      </td>
      <td valign="top" class="td5">
        <p class="p2">TDRTweet.h</p>
        <p class="p2">TDRTweet.m</p>
      </td>
    </tr>
  </tbody>
</table>
<p class="p3"><br></p>
<p class="p4"><b>Overview</b></p>
<p class="p5">A data model class designed to store the details of a single tweet.</p>
<p class="p4"><b>Tasks</b></p>
<ul class="ul1">
  <li class="li6">  userHandle<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">  tweetID<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">  tweetText<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">  dateString<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">  avatarURLString<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">  coordinate<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">– initWithUserHandle:tweetID:tweetText:timestamp:latitude:longitude:</li>
</ul>
<p class="p3"><br></p>
<p class="p4"><b>Properties</b></p>
<p class="p7">avatarURLString</p>
<p class="p8">The URL of the avatar image for the Twitter user who posted the tweet represented by the new instance of TDRTweet.</p>
<p class="p9">@property (strong, nonatomic) NSString *avatarURLString</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">The URL of the avatar image for the Twitter user who posted the tweet represented by the new instance of TDRTweet.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweet.h</p>
<p class="p12"><br></p>
<p class="p7">coordinate</p>
<p class="p8">The CLLocationCoordinate2D struct storing the posting location the tweet represented by the new instance of TDRTweet.</p>
<p class="p9">@property (assign, nonatomic) CLLocationCoordinate2D coordinate</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">The CLLocationCoordinate2D struct storing the posting location the tweet represented by the new instance of TDRTweet.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweet.h</p>
<p class="p12"><br></p>
<p class="p7">dateString</p>
<p class="p8">A string specifying the date of the tweet represented by the new instance of TDRTweet.</p>
<p class="p9">@property (strong, nonatomic) NSString *dateString</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">A string specifying the date of the tweet represented by the new instance of TDRTweet.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweet.h</p>
<p class="p12"><br></p>
<p class="p7">tweetID</p>
<p class="p8">The unique Twitter ID of the tweet represented by the new instance of TDRTweet.</p>
<p class="p9">@property (strong, nonatomic) NSString *tweetID</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">The unique Twitter ID of the tweet represented by the new instance of TDRTweet.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweet.h</p>
<p class="p12"><br></p>
<p class="p7">tweetText</p>
<p class="p8">The actual content of the tweet represented by the new instance of TDRTweet.</p>
<p class="p9">@property (strong, nonatomic) NSString *tweetText</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">The actual content of the tweet represented by the new instance of TDRTweet.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweet.h</p>
<p class="p12"><br></p>
<p class="p7">userHandle</p>
<p class="p8">The user handle of the tweet.</p>
<p class="p9">@property (strong, nonatomic) NSString *userHandle</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">The user handle of the tweet.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweet.h</p>
<p class="p14"><br></p>
<p class="p15"><br></p>
<p class="p4"><b>Instance Methods</b></p>
<p class="p7">initWithUserHandle:tweetID:tweetText:timestamp:latitude:longitude:</p>
<p class="p8">&lt;#Description#&gt;</p>
<p class="p9">- (instancetype)initWithUserHandle:(NSString *)<i>userHandle</i> tweetID:(NSString *)<i>tweetID</i> tweetText:(NSString *)<i>tweetText</i> timestamp:(NSString *)<i>dateString</i> latitude:(NSNumber *)<i>latitude</i> longitude:(NSNumber *)<i>longitude</i></p>
<p class="p10"><b>Parameters</b></p>
<p class="p13">userHandle</p>
<p class="p8">the user handle of the tweet represented by the new instance of TDRTweet.</p>
<p class="p13">tweetID</p>
<p class="p8">the unique Twitter ID of the tweet represented by the new instance of TDRTweet.</p>
<p class="p13">tweetText</p>
<p class="p8">the actual content of the tweet represented by the new instance of TDRTweet.</p>
<p class="p13">dateString</p>
<p class="p8"><span class="s1">dateString</span> a string specifying the date of the tweet represented by the new instance of TDRTweet.</p>
<p class="p13">latitude</p>
<p class="p8">the numerical latitude of the tweet represented by the new instance of TDRTweet.</p>
<p class="p13">longitude</p>
<p class="p8">the numerical longitude of the tweet represented by the new instance of TDRTweet.</p>
<p class="p10"><b>Return Value</b></p>
<p class="p8">A newly initialized instance of TDRTweet.</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">&lt;#Description#&gt;</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweet.h</p>
<p class="p14"><br></p>
<p class="p14"><br></p>
<p class="p14"><br></p>
<h2>TDRTweetsNearMeViewController Class Reference</h2>
<table cellspacing="0" cellpadding="0" class="t1">
  <tbody>
    <tr>
      <td valign="top" class="td1">
        <p class="p2"><b>Inherits from</b></p>
      </td>
      <td valign="top" class="td6">
        <p class="p2">UIViewController</p>
      </td>
    </tr>
    <tr>
      <td valign="top" class="td1">
        <p class="p2"><b>Declared in</b></p>
      </td>
      <td valign="top" class="td6">
        <p class="p2">TDRTweetsNearMeViewController.h</p>
        <p class="p2">TDRTweetsNearMeViewController.m</p>
      </td>
    </tr>
  </tbody>
</table>
<p class="p3"><br></p>
<p class="p4"><b>Overview</b></p>
<p class="p5">A concrete subclass of UIViewController that displays the geolocation of Tweets within a proximity of the running device.</p>
<p class="p16"><br></p>
<p class="p16"><br></p>
<h2>TDRTweetDetailViewController Class Reference</h2>
<table cellspacing="0" cellpadding="0" class="t1">
  <tbody>
    <tr>
      <td valign="top" class="td1">
        <p class="p2"><b>Inherits from</b></p>
      </td>
      <td valign="top" class="td7">
        <p class="p2">UIViewController</p>
      </td>
    </tr>
    <tr>
      <td valign="top" class="td1">
        <p class="p2"><b>Declared in</b></p>
      </td>
      <td valign="top" class="td7">
        <p class="p2">TDRTweetDetailViewController.h</p>
        <p class="p2">TDRTweetDetailViewController.m</p>
      </td>
    </tr>
  </tbody>
</table>
<p class="p3"><br></p>
<p class="p4"><b>Overview</b></p>
<p class="p5">A concrete subclass of UIViewController that displays details of a specifict Tweet passed in as a TDRTweet instance via the <span class="s1">tweet</span> property. It also facilitates the <span class="s1">tweet</span> being toggled on/off as a favorite by the user.</p>
<p class="p4"><b>Tasks</b></p>
<ul class="ul1">
  <li class="li6">  tweet<span class="s2"> </span><span class="s3">property</span></li>
  <li class="li6">  tweetsController<span class="s2"> </span><span class="s3">property</span></li>
</ul>
<p class="p3"><br></p>
<p class="p4"><b>Properties</b></p>
<p class="p7">tweet</p>
<p class="p8">The TDRTweet instance passed in for it’s details to be displayed.</p>
<p class="p9">@property (strong, nonatomic) TDRTweet *tweet</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">The TDRTweet instance passed in for it’s details to be displayed.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetDetailViewController.h</p>
<p class="p12"><br></p>
<p class="p7">tweetsController</p>
<p class="p8">The instance of TDRTweetsController to interact with during operations to change the favorite status of the <span class="s1">tweet</span> being displayed.</p>
<p class="p9">@property (strong, nonatomic) TDRTweetsController *tweetsController</p>
<p class="p10"><b>Discussion</b></p>
<p class="p8">The instance of TDRTweetsController to interact with during operations to change the favorite status of the <span class="s1">tweet</span> being displayed.</p>
<p class="p10"><b>Declared In</b></p>
<p class="p11">TDRTweetDetailViewController.h</p>
<p class="p17"><br></p>
<p class="p14"><br></p>
</body>
</html>

