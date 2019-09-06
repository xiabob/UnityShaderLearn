using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chapter12_ImageBlend : PostEffectBase
{
    [SerializeField] private Shader m_Shader;
    [SerializeField] private Texture m_MainTex;

    private Material m_ShaderMaterial;
    public Material ShaderMaterial
    {
        get
        {
            m_ShaderMaterial = CreateMaterialByShader(m_Shader, m_ShaderMaterial);
            return m_ShaderMaterial;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (ShaderMaterial != null)
        {
            ShaderMaterial.SetTexture("_BloomTex", src);
            Graphics.Blit(m_MainTex, dest, ShaderMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
