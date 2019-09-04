Shader "Unity Shader Book/Chapter 11/Image Sequence Animation"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" { }
        _Speed ("Animation Speed", float) = 30
        _SpriteRowCount ("Sprite Row Count", float) = 8
        _SpriteColumnCount ("Sprite Column Count", float) = 8
    }
    
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        
        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            float _Speed;
            float _SpriteRowCount;
            float _SpriteColumnCount;
            
            struct a2v
            {
                float4 vertex: POSITION;
                fixed4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                fixed2 uv: TEXCOORD0;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                float time = floor(_Time.y * _Speed);
                float row = floor(time / _SpriteColumnCount);
                float column = max(0, time - row * _SpriteColumnCount - 1);
                half uvX = i.uv.x / _SpriteColumnCount + column / _SpriteColumnCount;
                half uvY = i.uv.y / _SpriteRowCount + (_SpriteRowCount - row) / _SpriteRowCount;
                fixed4 color = tex2D(_MainTex, half2(uvX, uvY));
                return color;
            }
            
            ENDCG
            
        }
    }
    
    Fallback "diffuse"
}
