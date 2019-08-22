Shader "Unity Shader Book/Chapter6/BlinnPhong"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
        _Specular ("Specular", Color) = (1.0, 1.0, 1.0, 1.0)
        _Gloss ("Gloss", Range(8.0, 100)) = 20
    }
    
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            #include "UnityCG.cginc"
            
            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 position: SV_POSITION;
                float4 worldPosition: TEXCOORD0;
                float3 worldNormal: NORMAL;
            };
            
            v2f vert(a2v i)
            {
                v2f o;
                o.position = UnityObjectToClipPos(i.vertex);
                o.worldPosition = mul(unity_ObjectToWorld, i.vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(i.normal));
                return o;
            }
            
            fixed4 frag(v2f i): SV_TARGET {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 worldLight = normalize(_WorldSpaceLightPos0.rgb);
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(i.worldNormal, worldLight));

                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPosition));
                float3 h = normalize(viewDir + worldLight);
                float3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(i.worldNormal, h)), _Gloss);

                fixed3 color = ambient + diffuse + specular;

                return fixed4(color, 1.0);
             }
            
            ENDCG
            
        }
    }
    
    Fallback "Specular"
}
