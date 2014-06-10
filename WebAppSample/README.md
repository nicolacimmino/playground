
WEB App Sample
=============

This is a skeleton web application that demonstrates how to build an application that runs fully on the client side and doesn't rely on network connection. The user can interact with the application in his browser (single page application) and his actions are synced to the server in background. Application status is also fullly preserved should the browser be closed or should the user navigate to another page. Makes use of HTML5 browser local storage and background workers.

Note that this is just an architectural study item developed purely with HTML5 and Javascript with the support of JQuery. If you want to develop an actual application you will be much better off using a framework such as Angular.js as things will soon become more complicated in real life application. This is a good reference anyway to understand how things really work under the hood before jumping into frameworks magic.

The picture below gives a rough idea of the system architecture. The application is a single HTML+javascript page with which the user interacts. In practice the page is made of several "screens" that are hidden, shown and modified following user interaction. Any consequence of user action that needs to be stored doesn't go directly to the server but to the local storage, that is available even when there is no network. Meanwhile a background worker takes care to sync all data with the server when needed.

![Structure](https://raw.github.com/nicolacimmino/playground/master/WebAppSample/documentation/structure.png)

Because the application data is in the local storage, it can be preserved and re-rendered even if the browser is closed and re-opened or the page reloaded. The main benefit anyhow is that the application keeps being responsive even when connection is flacky or just lost, this wouldn't be possibile with the traditional approach that submits every action to the server and loads a new page as result.

Below is a screenshot of the sample application. User has a "play" button to start action. When "play" is pressed a timer starts to count. User can interact with 3 action buttons and his actions will be recorded in the "history" page. A status line on top indicates "Sync ongoing..." while there is data pending syncronization with the server.

![Screenshot](https://raw.github.com/nicolacimmino/playground/master/WebAppSample/documentation/screenshot.png)
