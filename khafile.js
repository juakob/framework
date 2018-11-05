let project = new Project('superFramework');

project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

resolve(project);
