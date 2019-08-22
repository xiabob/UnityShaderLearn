Shader "Unity Shader Book/Chapter6/Specular Vertex-Level"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
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
                float4 position: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 position: SV_POSITION;
                float3 color: COLOR;
            };
            
            v2f vert(a2v i)
            {
                v2f o;
                o.position = UnityObjectToClipPos(i.position);
                
                // ambient
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
                
                // calculate diffuse
                float3 worldNormal = normalize(UnityObjectToWorldNormal(i.normal));
                float3 worldLight = normalize(_WorldSpaceLightPos0.rgb);
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLight));
                
                // calculate specular
                float3 r = normalize(reflect(-_WorldSpaceLightPos0.rgb, worldNormal));
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.position.xyz));
                float3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(viewDir, r)), _Gloss);
                
                o.color = ambient + diffuse + specular;

                return o;
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                return fixed4(i.color, 1);
            }
            
            ENDCG
            
        }
    }
    
    
    Fallback "Specular"
}
