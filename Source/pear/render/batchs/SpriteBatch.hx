package pear.render.batchs;

import lime.math.Matrix4;
import pear.system.AssetsBackend;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.Float32Array;
import lime.graphics.opengl.GLBuffer;
import pear.core.PearEngine;

class SpriteBatch {
    var shader:Shader;
    var glVertexAttribute:Int;
    var glTextureAttribute:Int;
    var glMatrixUniform:GLUniformLocation;
    var glTranslationUniform:GLUniformLocation;
    var imageUniform:GLUniformLocation;
    var glBuffer:GLBuffer;

    public function new() {
        var vertexSource = "attribute vec4 aPosition;\n" +
        "attribute vec2 aTexCoord;\n" +
        "varying vec2 vTexCoord;\n" +
        "uniform mat4 u_translation;\n" +
        "uniform mat4 u_projection;\n" +
        "void main(void) {\n" +
        "  vTexCoord = aTexCoord;\n" +
        "  gl_Position = u_projection * u_translation * aPosition;\n" +
        "}";

        var fragmentSource = 
                "varying vec2 vTexCoord;\n" +
                "uniform sampler2D uImage0;\n" +
                "void main(void) {\n" +
                "  gl_FragColor = texture2D(uImage0, vTexCoord);\n" +
                "}";

        shader = new Shader(vertexSource, fragmentSource);
        shader.activate();

        glVertexAttribute = PearEngine.gl.getAttribLocation(shader.program, "aPosition");
        glTextureAttribute = PearEngine.gl.getAttribLocation(shader.program, "aTexCoord");
        glMatrixUniform = PearEngine.gl.getUniformLocation(shader.program, "u_projection");
        glTranslationUniform = PearEngine.gl.getUniformLocation(shader.program, "u_translation");
        imageUniform = PearEngine.gl.getUniformLocation(shader.program, "uImage0");

        PearEngine.gl.uniform1i(imageUniform, 0);

        glBuffer = PearEngine.gl.createBuffer();

        shader.deactivate();
    }

    public function drawSprite(texture:Texture, ?matrix:Matrix4, ?targetWidth:Float = -1, ?targetHeight:Float = -1, ?sourceX:Float = 0, ?sourceY:Float = 0, ?sourceWidth:Float = -1, ?sourceHeight:Float = -1) {
        
        targetWidth = targetWidth <= 0 ? texture.width : targetWidth;
        targetHeight = targetHeight <= 0 ? texture.height : targetHeight;

        sourceWidth = sourceWidth <= 0 ? texture.width : sourceWidth;
        sourceHeight = sourceHeight <= 0 ? texture.height : sourceHeight;

        shader.activate();
        PearEngine.gl.enableVertexAttribArray(glVertexAttribute);
        PearEngine.gl.enableVertexAttribArray(glTextureAttribute);
        PearEngine.gl.uniform1i(imageUniform, 0);

        var vX:Float = sourceX / texture.width;
        var vY:Float = sourceY / texture.height;

        var vX2:Float = sourceWidth / texture.width;
        var vY2:Float = sourceHeight / texture.height;

        var data = [
            targetWidth, targetHeight, 0, vX + vX2, vY + vY2,
            0, targetHeight, 0, vX, vY + vY2,
            targetWidth, 0, 0, vX + vX2, vY,
            0, 0, 0, vX, vY
        ];

        PearEngine.gl.bindBuffer(PearEngine.gl.ARRAY_BUFFER, glBuffer);
        PearEngine.gl.bufferData(PearEngine.gl.ARRAY_BUFFER, new Float32Array(data), PearEngine.gl.STATIC_DRAW);
        PearEngine.gl.bindBuffer(PearEngine.gl.ARRAY_BUFFER, null);

        PearEngine.gl.uniformMatrix4fv(glMatrixUniform, false, PearEngine.projection);
        PearEngine.gl.uniformMatrix4fv(glTranslationUniform, false, matrix ?? new Matrix4());

        PearEngine.gl.activeTexture(PearEngine.gl.TEXTURE0);
        texture.bind();

        PearEngine.gl.bindBuffer(PearEngine.gl.ARRAY_BUFFER, glBuffer);
        PearEngine.gl.vertexAttribPointer(glVertexAttribute, 3, PearEngine.gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
        PearEngine.gl.vertexAttribPointer(glTextureAttribute, 2, PearEngine.gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);

        PearEngine.gl.drawArrays(PearEngine.gl.TRIANGLE_STRIP, 0, 4);
        shader.deactivate();
        texture.unbind();
    }
}