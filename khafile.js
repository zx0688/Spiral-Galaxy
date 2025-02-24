let project = new Project('VolkaTest');
project.addAssets('Assets/**');
project.addShaders('Shaders');
project.addSources('Sources');

project.windowOptions.width = 1920;
project.windowOptions.height = 1080;

resolve(project);
