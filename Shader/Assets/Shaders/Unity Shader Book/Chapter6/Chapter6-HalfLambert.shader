Shader "Unity Chapter Book/Chapter6/Half Lambert"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
    }
    
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            
            fixed4 _Diffuse;
            
            struct a2v
            {
                float4 position: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 position: SV_POSITION;
                float3 worldNormal: NORMAL;
            };
            
            v2f vert(a2v i)
            {
                v2f o;
                o.position = UnityObjectToClipPos(i.position);
                o.worldNormal = UnityObjectToWorldNormal(i.normal);
                return o;
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                fixed3 worldLight = normalize(_WorldSpaceLightPos0);
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * (dot(i.worldNormal, worldLight) * 0.5 + 0.5);
                fixed3 color = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb;
                return fixed4(color, 1);
            }
            
            ENDCG
            
        }
    }
    
    Fallback "Diffuse"
}
