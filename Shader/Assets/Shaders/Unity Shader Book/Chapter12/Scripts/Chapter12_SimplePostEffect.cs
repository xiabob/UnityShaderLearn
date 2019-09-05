using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chapter12_SimplePostEffect : PostEffectBase
{

    [SerializeField] private Shader m_Shader;
    [Range(0, 2)]
    [SerializeField] private float m_Brightness = 1;
    [Range(-1, 1)]
    [SerializeField] private float m_Saturation = 0;
    [Range(0, 2)]
    [SerializeField] private float m_Contrast = 1;

    private Material m_ShaderMaterial;
    public Material ShaderMaterial
    {
        get
        {
            m_ShaderMaterial = CreateMaterialByShader(m_Shader, m_ShaderMaterial);
            return m_ShaderMaterial;
        }
    }

    // Start is called before the first frame update
    void Start()
    {

    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (ShaderMaterial != null)
        {
            ShaderMaterial.SetFloat("_Brightness", m_Brightness);
            ShaderMaterial.SetFloat("_Saturation", m_Saturation);
            ShaderMaterial.SetFloat("_Contrast", m_Contrast);
            Graphics.Blit(src, dest, ShaderMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

}
