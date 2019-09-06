Shader "Hidden/Chapter12_LuminanceShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _LuminanceThreshold ("Luminance Threshold", float) = 0.5
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
        
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float _LuminanceThreshold;
            
            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            fixed luminance(fixed4 color)
            {
                return color.r * 0.2125 + color.g * 0.7154 + color.b * 0.0721;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed val = clamp(luminance(col) - _LuminanceThreshold, 0, 1.0);
                return col * val;
            }
            ENDCG
            
        }
    }
}
