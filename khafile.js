let project = new Project('SpiralGalaxy');
project.addAssets('Assets/**');
project.addShaders('Shaders');
project.addSources('Sources');


project.targetOptions.html5.disableContextMenu = true;
project.windowOptions.width = 2560;
project.windowOptions.height = 1440;

project.windowOptions.resizable = false;
project.windowOptions.fullscreen = true;

resolve(project);
