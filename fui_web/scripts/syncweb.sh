#!/bin/sh
cd ..
flutter build web --dart-define=ENV=prod
cd build/web
rsync -avcPz \
	--delete \
	* fui:/fridayy/web
