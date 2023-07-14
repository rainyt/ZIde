import element.plus.ElementPlus;
import vue3.Vue;
import app.App;

class Main {
	static function main() {
        trace("ZIde v2.0 inited");
		var config = new App();
		var app = Vue.createApp(config);
        app.use(ElementPlus);
		app.mount("#app");
	}
}
